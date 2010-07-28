module ActionThrottler
  class Actions
    class << self
      # Adds an action to the stack
      # 
      # @param [Symbol] action the name of the action, must be unique
      # @param [Block]  block  the configuration block
      def add(action = nil, &block)
        @actions ||= {}
        
        raise "A name to the ActionThrottler action is required!" if action.nil?
        
        config = ActionThrottler::Config.new
        block.call(config)

        @actions[action] = config.to_hash
      end
      
      # Checks the database to see if an action can be run
      # 
      # @param  [Symbol]  action the name of the action to be run
      # @param  [Mixed]   ref    (optional) the reference object
      # @return [Boolean]        returns true or false depending on the outcome
      def can_be_run?(action, ref = "")
        ::ActionThrottlerLog.all(:conditions => [
          "scope = ? AND reference = ? AND created_at >= ?",
          action.to_s,
          normalise_ref(ref),
          @actions[action][:duration].ago
        ]).size < @actions[action][:limit] ? true : false
      end
      
      # @see self::can_be_run?
      def cannot_be_run?(action, ref = "")
        not can_be_run?(action, ref)
      end
      
      # Runs an action and registers it in the database
      # 
      # @param  [Symbol]  action the name of the action to be run
      # @param  [Mixed]   ref    (optional) the reference object
      # @return [Boolean]        returns true or false depending on the outcome
      def run(action, ref = "")
        if can_be_run?(action, ref)
          ::ActionThrottlerLog.create({
            :scope     => action.to_s,
            :reference => normalise_ref(ref)
          })
        else
          false
        end
      end
      
      # @see self::run
      def can_run(action, ref = "")
        run(action, ref)
      end
      
      # @see self::run
      def cannot_run(action, ref = "")
        ! run(action, ref)
      end
      
      private
      
      # Normalises the ref parameter so it can accept more than one type
      # 
      # @param [Mixed] ref the ref parameter
      # @return [String] ref id
      def normalise_ref(ref)
        (ref.is_a?(Integer) || ref.is_a?(String)) ? ref.to_s : ref.id.to_s
      end
    end
  end
end
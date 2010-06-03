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
      # @param  [Object]  ref    (optional) the reference object
      # @return [Boolean]        returns true or false depending on the outcome
      def can_be_run?(action, ref = "")
        ::ActionThrottlerLog.all(:conditions => [
          "scope = ? AND reference = ? AND created_at >= ?",
          action.to_s,
          normalise_ref(ref),
          @actions[action][:duration].ago
        ]).size < @actions[action][:limit] ? true : false
      end
      
      # Runs an action and registers it in the database
      # 
      # @param  [Symbol]  action the name of the action to be run
      # @param  [Object]  ref    (optional) the reference object
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
      
      def can_run(action, ref = "")
        run(action, ref)
      end
      
      def cannot_run(action, ref = "")
        ! run(action, ref)
      end
      
      private
      
      # Normalises the ref parameter so it can accept more than one type
      # 
      # @param [Object] ref the ref parameter
      def normalise_ref(ref)
        (ref.is_a?(Integer) or ref.is_a?(String)) ? ref : ref.id
      end
    end
  end
end
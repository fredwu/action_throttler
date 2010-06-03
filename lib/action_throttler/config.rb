module ActionThrottler
  class Config
    def initialize
      @config ||= {}
    end
    
    def to_hash
      @config
    end
    
    def method_missing(key, value)
      # converts `key=()` methods to `key()`
      key = key.to_s.sub(/=$/, "").to_sym
      
      @config[key] = value
    end
  end
end
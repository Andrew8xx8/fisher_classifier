module FisherClassifier
  class Config

    def initialize(block)
      @config = {
        weight: 1.0,
        ap: 0.5
      }
      @methods = {}
      instance_eval &block
    end

    def get(key)
      raise "'#{key}' value does not defined in config" unless @config.has_key? key

      @config[key]
    end

    def call(name, *args)
      raise "'#{name}' mehtod does not defined in config" unless @methods.has_key? name

      @methods[name].call *args
    end

    def method_missing(key, value = nil, &block)
      if block_given?
        @methods[key] = block
      else
        @config[key] = value
      end
    end

  end
end

module Scraper
  class ExtractElementError < StandardError; end

  class UnSupportedError < StandardError
    attr_accessor :type
    def initialize(type)
      @type = type

      super
    end

    def message
      "#{type.capitalize} is not supported yet."
    end
  end

  class OutdatedError < StandardError
    attr_accessor :key, :identifier

    def initialize(key, identifier)
      @key = key
      @identifier = identifier

      super
    end

    def message
      "#{key.capitalize} doesn't fetch any result! Review #{identifier}."
    end
  end
end

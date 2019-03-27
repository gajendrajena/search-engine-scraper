require 'open-uri'

module Scraper
  class GoogleScraper
    attr_accessor :page, :keyword, :url

    BASE_URL = 'https://google.com'.freeze
    DEFAULT_RELATIVE_SEARCH_URL = 'search?q='.freeze
    TRACKABLE_ATTRIBUTES = {
      total_result: {
        type: 'number',
        identifier: '#resultStats'
      },
      adwords: {
        type: 'ads',
        identifier: '.ads-ad h3 a'
      },
      links: {
        type: 'link',
        identifier: '',
      }
    }


  class EmptyKeywordError < StandardError; end
  class ExtractElementError < StandardError; end
  class ParseError < StandardError; end
  class ScrapeError < StandardError; end
  class InvalidArgumentError < StandardError; end

  class UnSupportedError < StandardError
    attr_accessor :type

    def initialize(type)
      @type = type

      super(message)
    end

    def message
      "#{@type.capitalize} is not supported yet."
    end
  end

  class OutdatedError < StandardError
    attr_accessor :key, :identifier

    def initialize(key, identifier)
      @key = key
      @identifier = identifier

      super(message)
    end

    def message
      "#{@key.capitalize} doesn't fetch any result! Review #{identifier}."
    end
  end

    def scrap(options={})
      @keyword = options[:keyword]
      raise EmptyKeywordError and return if @keyword.blank?

      # Build URL
      @url =  "#{BASE_URL}/#{DEFAULT_RELATIVE_SEARCH_URL}#{@keyword.split(/\s+/).join('+')}"

      # Call the URL
      @page = web_search

      # Scan the page for trackable attributes
      scrap_data = parse_page()
      scrap_data[:keyword] = @keyword
      scrap_data[:user_id] = options[:user_id]

      SearchResult.create_from_scrap_data(scrap_data)

      scrap_data
    rescue ParseError
      # log(ex) Log it to any service / third party library e.g. bugsnag
      raise ScrapeError
    end

    def web_search
      Nokogiri::HTML(open(@url))
    end

    # parse html @page for extracting different data
    def parse_page
      {}.tap do |attrs|
        TRACKABLE_ATTRIBUTES.each do |k, v|
          attrs[k] = extract_elements(k, v[:type], v[:identifier])
        end
        attrs[:html] = @page.to_html
      end
    rescue ExtractElementError
      # log(ex) Log it to any service / third party library e.g. bugsnag
      raise ParseError
    end

    # extract a specific data from html @page
    def extract_elements(key, type, identifier)
      case type
      when 'number'
        total = @page.at_css(identifier).try(:text).try(:delete, '^0-9')

        # NOTE: Since the total represents the total number of search results,
        # if there is no results there could be two cases.
        # 1. The `keyword` is wrong or have typo error
        # 2. The identifier we have used is outdated and Google has changed
        # their DOM structure.
        #
        # Since we are (hopefully) using a curated list of keywords, it's mostly
        # the second case. So, raise an OutdatedError when there is no results.
        raise OutdatedError.new(key, identifier) if total.nil?

        total
      when 'ads'
        @page.css(identifier).map {|link| link.attr('href') }
      when 'link'
        @page.css("a#{identifier}").map {|lnk| lnk.attributes['href'] }
      else
        raise UnSupportedError.new(type)
      end
    rescue OutdatedError, UnSupportedError
      # log(ex) Log it to any service / third party library e.g. bugsnag
      raise ExtractElementError
    end
  end

end


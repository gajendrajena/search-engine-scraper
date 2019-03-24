require 'open-uri'
require_relative './scraper_error.rb'

module Scraper
  class GoogleScraper
    attr_accessor :page, :keyword, :url

    BASE_URL = 'https://google.com'.freeze
    DEFAULT_RELATIVE_SEARCH_URL = 'search?q='.freeze
    DEFAULT_KEYWORD = 'nimble'
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

    def scrap(options={})
      # Build URL
      @keyword = options[:keyword] || DEFAULT_KEYWORD
      @url =  "#{BASE_URL}/#{DEFAULT_RELATIVE_SEARCH_URL}#{@keyword.split(/\s+/).join('+')}"
      p "URL is #{@url}"

      # Call the URL
      @page = Nokogiri::HTML(open(@url))

      # Scan the page for trackable attributes
      parse_page
    rescue OutdatedError, UnSupportedError
      # log(ex) Log it to any service / third party library e.g. bugsnag
      raise ExtractElementError
    end

    # parse html @page for extracting different data
    def parse_page
      {}.tap do |attrs|
        TRACKABLE_ATTRIBUTES.each do |k, v|
          attrs[k] = extract_elements(k, v[:type], v[:identifier])
        end
        attrs[:html] = @page.to_html
      end
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
        @page.css("a#{identifier}").map {|lnk| lnk.attributes['href'].value }
      else
        raise UnSupportedError.new(type)
      end
    end
  end

end

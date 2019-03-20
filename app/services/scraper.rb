require_relative './scraper/google_scraper'

module Scraper
  class SearchEngineScraper
    attr_accessor :scraper

    def initialize(search_engine="google")
      @scraper = SearchEngineScraper.for(search_engine)
    end

    def self.for(search_engine)
      case search_engine
      when 'google'
        ::Scraper::GoogleScraper.new
      else
        nil
      end
    end

    def scrap(options={})
      # options is the Scrapper specific options
      @scraper.scrap(options)
    end
  end
end

require 'open-uri'

module Scraper
  class GoogleScraper
    BASE_URL = 'https://google.com'.freeze
    DEFAULT_RELATIVE_SEARCH_URL = 'search?q='.freeze

    def scrap(options={})
      opts = {
        relative_url: DEFAULT_RELATIVE_SEARCH_URL,
        keyword: 'ruby'
      }.merge(options)

      # Build URL
      url = [
        BASE_URL,
        opts[:relative_url]
      ].join("/")

      # Call the URL
      html = Nokogiri::HTML(open(url))

      # Read the Data
      # Format the Data
    end
  end
end

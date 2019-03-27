class GoogleScrapeJob < ApplicationJob
  queue_as :default


  def perform(*args)
    begin
      if args[0][:keyword].present? && args[0][:user_id].present?
        scrap_data = Scraper::GoogleScraper.new.scrap(args[0])
      else
        Rails.logger.error("Error scraping #{args[0]}")
        raise Scraper::GoogleScraper::InvalidArgumentError
      end
    rescue Scraper::GoogleScraper::ExtractElementError
      Rails.logger.error("Error scraping #{args[0]}")
    end
  end
end

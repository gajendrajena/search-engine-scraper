class GoogleScrapWorker
  include Sidekiq::Worker

  def perform(keyword, user_id=0)
    begin
      scrap_data = Scraper::GoogleScraper.new.scrap({ keyword: keyword, user_id: user_id })
    rescue Scraper::GoogleScraper::ExtractElementError
      Rails.logger.error("Error scraping #{keyword}")
    end
  end
end

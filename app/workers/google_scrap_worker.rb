class GoogleScrapWorker
  include Sidekiq::Worker

  def perform(keyword)
    Scraper::GoogleScraper.new.scrap({ keywords: keyword })
  end
end

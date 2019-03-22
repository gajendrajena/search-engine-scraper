class GoogleScrapWorker
  include Sidekiq::Worker

  def perform(keyword)
    puts '*' * 200
    puts "triggering Scraper::GoogleScraper.new.scrap worker for keyword: #{keyword}"
    scrap_data = Scraper::GoogleScraper.new.scrap({ keyword: keyword })
    puts '*' * 200
    puts scrap_data.inspect
  end
end

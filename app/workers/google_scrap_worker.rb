class GoogleScrapWorker
  include Sidekiq::Worker

  def perform(keyword, user_id=0)
    puts '*' * 200
    puts "triggering Scraper::GoogleScraper.new.scrap worker for keyword: #{keyword}"
    scrap_data = Scraper::GoogleScraper.new.scrap({ keyword: keyword, user_id: user_id })
    puts '*' * 200
    # puts scrap_data.inspect
  end
end

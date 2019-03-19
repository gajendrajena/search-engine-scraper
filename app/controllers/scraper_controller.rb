class ScraperController < ApplicationController
  before_action :authenticate_user!

  def scrap
    scraper = Scraper::SearchEngineScraper.new
    @data = scraper.scrap
  end
end

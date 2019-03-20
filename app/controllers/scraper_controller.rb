class ScraperController < ApplicationController
  before_action :authenticate_user!

  def scrap
    scraper = Scraper::SearchEngineScraper.new
    @data = scraper.scrap
  rescue Scraper::ExtractElementError => ex
    render json: { message: "Unable to scrap", status: :unprocessable_entity }
  rescue StandardError
    render json: { message: "Unable to process request", status: :internal_error }
  end
end

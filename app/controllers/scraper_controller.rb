class ScraperController < ApplicationController
  before_action :authenticate_user!

  def scrap
    begin
      keywords = SearchResult.process_keywords_csv(params[:file])
    rescue Scraper::ExtractElementError => ex
      flash[:error] = "Unable to scrap"
    rescue StandardError
      flash[:error] = "Unable to process request"
    end
    redirect_to '/'
  end

end

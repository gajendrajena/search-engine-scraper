class ScraperController < ApplicationController
  before_action :authenticate_user!

  def scrap
    begin
      SearchResult.process_keywords_csv(params[:file], current_user.try(:id))
      flash[:notice] = "Uploaded successfully"
    rescue Exception => e
      flash[:error] = "Unable to process request"
    end

    redirect_to '/'
  end

end

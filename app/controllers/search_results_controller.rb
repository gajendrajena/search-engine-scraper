class SearchResultsController < ApplicationController
  before_action :set_search_result, only: [:show]
  before_action :authenticate_user!, only: [:index, :show]

  # GET /search_results
  # GET /search_results.json
  def index
    @search_results = current_user.search_results
  end

  # GET /search_results/1
  # GET /search_results/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_result
      @search_result = SearchResult.find(params[:id])
    end
end

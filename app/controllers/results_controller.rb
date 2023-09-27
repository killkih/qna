class ResultsController < ApplicationController

  def index
    @search_results = SearchService.new(params[:query], params[:resource]).call
  end
end

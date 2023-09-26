class ResultsController < ApplicationController

  def index
    @search_results = Question.search_everywhere(params[:query])
  end
end

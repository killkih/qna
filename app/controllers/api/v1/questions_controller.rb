# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  include Rails.application.routes.url_helpers

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end
end

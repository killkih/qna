# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  include Rails.application.routes.url_helpers

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
  end

  private

  def question
    @question ||= Question.find(params[:id]) if params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[title image])
  end
end

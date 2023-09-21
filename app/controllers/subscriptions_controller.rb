# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    current_user.subscriptions.create(question: question)
  end

  def destroy
    current_user.subscriptions.find_by(question: question)&.destroy
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end
end

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    @exposed_answer.user = current_user

    if @exposed_answer.save
      redirect_to question_path(question), notice: 'Answer added successfully!'
    else
      redirect_to question_path(question), notice: 'Error adding answer'
    end
  end

  def destroy
      question = answer.question

    if current_user.id == answer.user_id
      answer.destroy
      redirect_to question_path(question), notice: 'Answer successfully deleted!'
    else
      redirect_to question_path(question), notice: 'Only the author can delete a answer!'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

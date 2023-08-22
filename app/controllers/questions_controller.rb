# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :gon_question_id, only: [:show]
  before_action :gon_question_user_id, only: [:show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def new
    question.links.new
    reward = Reward.new
    question.reward = reward
  end

  def show
    @answer = question.answers.new
    @answer.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def edit; end

  def destroy
    if current_user.id == question.user_id
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted!'
    else
      redirect_to question_path(question), notice: 'Only the author can delete a question!'
    end
  end

  def purge
    file = question.files.find(params[:file])
    file.purge
    redirect_to question_path(question)
  end

  private

  def gon_question_id
    gon.question_id = question.id
  end

  def gon_question_user_id
    gon.question_user_id = question.user_id
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast('questions', question)
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[title image])
  end
end

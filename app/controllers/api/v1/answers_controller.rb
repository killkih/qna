class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end

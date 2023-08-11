module Voted
  extend ActiveSupport::Concern

  included { before_action :set_votable, only: %i[like dislike cancel_vote] }

  def like
    @votable.set_like(current_user)
    render_json
  end

  def dislike
    @votable.set_dislike(current_user)
    render_json
  end

  def cancel_vote
    @votable.cancel_vote(current_user)
    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: {id: @votable.id, rating: @votable.rating}
  end

end

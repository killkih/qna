module HasVote
  extend ActiveSupport::Concern

  included { has_many :votes, dependent: :destroy, as: :votable }

  def set_like(user)
    votes.find_or_create_by(user: user, status: true)
  end

  def set_dislike(user)
    votes.find_or_create_by(user: user, status: false)
  end

  def cancel_vote(user)
    votes.where(user: user).delete_all
  end

  def rating
    votes.where(status: true).count - votes.where(status: false).count
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User
    can :create, [Question, Answer]
    can :add_comment, [Question, Answer]
    can %i[update destroy purge], [Question, Answer], user_id: user.id
    can :mark_as_best, Answer, question: { user_id: user.id }
    can %i[like dislike cancel_vote], [Question, Answer] do |votable|
      votable.user_id != user.id
    end
  end
end

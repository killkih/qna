# frozen_string_literal: true

class User < ApplicationRecord
  include HasSearch
  include HasComment

  multisearchable against: [:email, :id]
  pg_search_scope :search, against: [:email, :id]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: %i[github vkontakte]

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def voted?(resource)
    votes.where(votable_id: resource).present?
  end

  def author?(resource)
    resource.user_id == id
  end

  def subscribed?(question)
    subscriptions.find_by(question: question)
  end
end

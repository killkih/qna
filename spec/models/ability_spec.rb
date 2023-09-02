require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Reward }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user, admin: false) }
    let(:other) { create(:user, admin: false) }
    let(:file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }

      it { should be_able_to :destroy, create(:question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:question, user: other), user: user }

      it { should be_able_to :purge, create(:question, files: file, user: user), user: user }
      it { should_not be_able_to :purge, create(:question, files: file, user: other), user: user }

      it { should be_able_to :like, question, user: other }
      it { should_not be_able_to :like, question, user: user }

      it { should be_able_to :dislike, question, user: other }
      it { should_not be_able_to :dislike, question, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other), user: user }

      it { should be_able_to :destroy, create(:answer, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

      it { should be_able_to :purge, create(:answer, files: file, user: user), user: user }
      it { should_not be_able_to :purge, create(:answer, files: file, user: other), user: user }

      it { should be_able_to :mark_as_best, answer, question: { user: user } }
      it { should_not be_able_to :mark_as_best, answer, question: { user: other } }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
  end
end
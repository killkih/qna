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
    let(:other_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    context 'Question' do
      let!(:vote) { create(:vote, user: user, votable: votable_question) }
      let(:votable_question) { create(:question, user: other) }

      it { should be_able_to :create, Question }

      it { should be_able_to [:update, :destroy], question, user: user }
      it { should_not be_able_to [:update, :destroy], other_question, user: user }

      it { should be_able_to :purge, create(:question, files: file, user: user), user: user }
      it { should_not be_able_to :purge, create(:question, files: file, user: other), user: user }

      it { should be_able_to [:like, :dislike], other_question }
      it { should_not be_able_to [:like, :dislike], question }

      it { should be_able_to :cancel_vote, votable_question }
    end

    context 'Answer' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:other_answer) { create(:answer, question: other_question, user: other) }
      let!(:vote_answer) { create(:vote, user: user, votable: votable_answer) }
      let(:votable_answer) { create(:answer, user: other) }

      let(:other_answer) { create(:answer, user: other, question: other_question) }

      it { should be_able_to :create, Answer }

      it { should be_able_to [:update, :destroy], answer, user: user }
      it { should_not be_able_to [:update, :destroy], other_answer, user: user }

      it { should be_able_to :purge, create(:answer, files: file, user: user), user: user }
      it { should_not be_able_to :purge, create(:answer, files: file, user: other), user: user }

      it { should be_able_to :mark_as_best, answer}
      it { should_not be_able_to :mark_as_best, other_answer}

      it { should be_able_to [:like, :dislike], other_answer }
      it { should_not be_able_to [:like, :dislike], answer }

      it { should be_able_to :cancel_vote, votable_answer }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end
  end
end

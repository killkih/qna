# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'linkable'
  it_behaves_like 'commentable'

  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward }

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls Services::Reputation#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end

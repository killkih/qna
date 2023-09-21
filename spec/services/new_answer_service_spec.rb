# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerService do
  let!(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question, user: other_user) }

  it 'sends new answer notice to users' do
    expect(NewAnswerMailer).to receive(:notice).with(user, answer).and_call_original
    expect(NewAnswerMailer).to receive(:notice).with(other_user, answer).and_call_original
    subject.send_notice(answer)
  end
end

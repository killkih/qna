# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'notice' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:subscription) { create(:subscription, user: user, question: question) }
    let(:mail) { NewAnswerMailer.notice(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notice')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end

require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswerService') }
  let!(:answer) { create(:answer, question: create(:question)) }

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerService#send_notice' do
    expect(service).to receive(:send_notice).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end

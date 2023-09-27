require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
  let(:service) { double('SearchService') }

  before do
    allow(SearchService).to receive(:new).and_return(service)
    allow(service).to receive(:call).and_return(PgSearch::Document)
    get :index, params: { query: 'test', resource: 'All' }
  end

  describe 'GET #index' do
    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'render template' do
      expect(response).to render_template :index
    end
  end
end

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:rewards) { create_list(:reward, 3, user: user) }

    before { login(user) }
    before { get :index }

    it 'populates a reward' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

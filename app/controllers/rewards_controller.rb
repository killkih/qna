# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @rewards = Reward.where(user_id: current_user)
  end
end

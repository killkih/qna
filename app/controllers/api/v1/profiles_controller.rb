# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    render json: user
  end

  private

  def user
    @user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: User
      def me
        render json: user
      end

      def index
        @users = User.where.not(id: user.id)
        render json: @users
      end

      private

      def user
        @user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end

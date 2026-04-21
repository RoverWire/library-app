# frozen_string_literal: true

module Api
  module V1
    module Users
      class ProfileController < Api::V1::ApplicationController
        def show
          render json: current_user, status: :ok
        end

        def update
          result = Users::UpdateProfile.call(current_user, user_params)

          if result.success?
            render json: { message: 'Profile updated successfully.', user: current_user }, status: :ok
          else
            render json: { errors: result.errors }, status: :unprocessable_content
          end
        end

        private

        def user_params
          params.expect(user: %i[first_name last_name email current_password password password_confirmation])
        end
      end
    end
  end
end

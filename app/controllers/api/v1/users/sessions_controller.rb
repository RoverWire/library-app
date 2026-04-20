# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        prepend_before_action :allow_params_authentication!, only: :create
        before_action :configure_sign_in_params, only: [:create]

        skip_before_action :verify_authenticity_token

        respond_to :json

        def create
          super
        end

        private

        def respond_with(resource, _opts = {})
          render json: { message: 'Logged in successfully.', user: resource }, status: :ok
        end

        def respond_to_on_destroy
          render json: { message: 'Logged out successfully.' }, status: :ok
        end

        def configure_sign_in_params
          devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
        end

        def resource_name
          :user
        end

        def devise_mapping
          Devise.mappings[:user]
        end
      end
    end
  end
end

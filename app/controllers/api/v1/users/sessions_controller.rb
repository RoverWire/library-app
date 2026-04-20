# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token
        prepend_before_action :allow_params_authentication!, only: :create
        before_action :configure_sign_in_params, only: [:create]

        respond_to :json

        def create
          super
        end

        private

        def respond_with(resource, _opts = {})
          if resource&.persisted?
            render json: { message: 'Logged in successfully.', user: resource }, status: :ok
          else
            render json: { message: 'Invalid credentials' }, status: :unauthorized
          end
        end

        def respond_to_on_destroy(_resource = nil)
          render json: { message: 'Logged out successfully.' }, status: :ok
        end

        def configure_sign_in_params
          devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
        end
      end
    end
  end
end

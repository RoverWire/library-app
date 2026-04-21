# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :verify_authenticity_token
        before_action :configure_sign_up_params, only: [:create]
        before_action :configure_account_update_params, only: [:update]

        respond_to :json

        def create
          super
        end

        def update
          super
        end

        private

        def respond_with(resource, _opts = {})
          if resource.errors.empty?
            message = action_name == 'create' ? 'Signed up successfully.' : 'User updated successfully.'

            render json: {
                     message: message,
                     user: resource
                   },
                   status: action_name == 'create' ? :created : :ok
          else
            render json: { message: 'Validation errors', errors: resource.errors.full_messages }, status: :unprocessable_content
          end
        end

        def configure_sign_up_params
          devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation first_name last_name])
        end

        def configure_account_update_params
          devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
        end
      end
    end
  end
end

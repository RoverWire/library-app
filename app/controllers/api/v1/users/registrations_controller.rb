# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :verify_authenticity_token
        before_action :configure_sign_up_params, only: [:create]

        respond_to :json

        def create
          super
        end

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: { message: 'Signed up successfully.', user: resource }, status: :created
          else
            render json: { message: 'User could not be created.', errors: resource.errors.full_messages }, status: :unprocessable_content
          end
        end

        def configure_sign_up_params
          devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation first_name last_name])
        end
      end
    end
  end
end

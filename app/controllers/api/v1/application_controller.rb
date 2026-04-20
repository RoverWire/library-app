# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      protect_from_forgery with: :null_session
      before_action :configure_permitted_parameters, if: :devise_controller?

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      respond_to :json

      private

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation])
      end

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def render_error(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_content
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include CanCan::ControllerAdditions

      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      rescue_from CanCan::AccessDenied do
        render json: { error: 'Forbidden' }, status: :forbidden
      end

      respond_to :json

      private

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def render_error(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_content
      end
    end
  end
end

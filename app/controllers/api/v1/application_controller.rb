# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

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

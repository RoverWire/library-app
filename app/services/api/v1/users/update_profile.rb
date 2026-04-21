# frozen_string_literal: true

module Api
  module V1
    module Users
      class UpdateProfile
        attr_accessor :user, :params

        Result = Struct.new(:success?, :user, :errors)
        private_constant :Result

        def self.call(user, params)
          new(user, params).call
        end

        def initialize(user, params)
          @user = user
          @params = params
        end

        def call
          if password_change?
            return failure unless valid_current_password?
            return failure unless passwords_match?
          end

          if @user.update(filtered_params)
            success
          else
            failure
          end
        end

        private

        def password_change?
          params[:password].present?
        end

        def valid_current_password?
          user.valid_password?(params[:current_password])
        end

        def passwords_match?
          params[:password] == params[:password_confirmation]
        end

        def filtered_params
          params.except(:current_password)
        end

        def success
          Result.new(success?: true, user: user)
        end

        def failure
          Result.new(success?: false, user: user, errors: user.errors.full_messages.presence || default_errors)
        end

        def default_errors
          if password_change? && !valid_current_password?
            ['Current password is incorrect']
          elsif password_change? && !passwords_match?
            ['Password confirmation does not match']
          else
            ['Unable to update user']
          end
        end
      end
    end
  end
end

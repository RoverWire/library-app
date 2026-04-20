# frozen_string_literal: true

module AuthHelpers
  def authenticate_user(user)
    post '/api/v1/users/login', params: { user: { email: user.email, password: user.password } }, as: :json

    token = response.headers['Authorization']&.split&.last

    {
      'Authorization' => "Bearer #{token}",
      'ACCEPT' => 'application/json'
    }
  end
end

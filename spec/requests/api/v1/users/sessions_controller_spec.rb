# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::SessionsController', type: :request do
  let(:user) { create(:user, password: 'password123', email: 'test@example.com') }
  let(:login_url) { '/api/v1/users/login' }
  let(:logout_url) { '/api/v1/users/logout' }

  describe 'POST /api/v1/users/login' do
    context 'with valid credentials' do
      before do
        post login_url, params: { user: { email: user.email, password: 'password123' } }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JWT token in the Authorization header' do
        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to include('Bearer')
      end
    end

    context 'with invalid credentials' do
      before do
        post login_url, params: { user: { email: user.email, password: 'wrong' } }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not return authorization header' do
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end

  describe 'DELETE /api/v1/users/logout' do
    context 'when user is logged in' do
      before do
        auth_headers = authenticate_user(user)
        delete logout_url, headers: auth_headers, as: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        json = response.parsed_body
        expect(json['message']).to eq('Logged out successfully.')
      end
    end
  end
end

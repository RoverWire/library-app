# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Auth', type: :request do
  let(:user) { create(:user, password: 'password123', email: 'test@example.com') }
  let(:login_url) { '/api/v1/users/login' }

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
      it 'returns unauthorized status' do
        post login_url, params: { user: { email: user.email, password: 'wrong' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

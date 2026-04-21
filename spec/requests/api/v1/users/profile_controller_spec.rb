# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::ProfileController', type: :request do
  let(:password) { 'password123' }
  let(:user) { create(:user, password: password, first_name: 'Old', last_name: 'Name') }
  let(:base_url) { '/api/v1/users/profile' }
  let(:headers) { authenticate_user(user) }

  describe 'GET /api/v1/users/profile' do
    context 'when user is authenticated' do
      before do
        get base_url, headers: headers, as: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns current user data' do
        json = response.parsed_body

        expect(json['email']).to eq(user.email)
        expect(json['first_name']).to eq(user.first_name)
      end
    end

    context 'when user is not authenticated' do
      before do
        get base_url, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/users/profile' do
    context 'with valid profile params' do
      before do
        patch base_url, params: { user: { first_name: 'Updated', last_name: 'User' } }, headers: headers, as: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates user profile' do
        user.reload

        expect(user.first_name).to eq('Updated')
        expect(user.last_name).to eq('User')
      end

      it 'returns success message' do
        json = response.parsed_body
        expect(json['message']).to eq('Profile updated successfully.')
      end
    end

    context 'with invalid params' do
      before do
        patch base_url, params: { user: { first_name: '' } }, headers: headers, as: :json
      end

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'returns errors from service' do
        json = response.parsed_body
        expect(json['errors']).to be_present
      end
    end

    context 'when not authenticated' do
      before do
        patch base_url, params: { user: { first_name: 'Hack' } }, as: :json
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

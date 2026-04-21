# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::Registrations', type: :request do
  let(:signup_url) { '/api/v1/users/signup' }
  let(:update_url) { '/api/v1/users/signup' }
  let(:user) { create(:user, password: 'password123', email: 'test@example.com') }

  describe 'POST /api/v1/users/signup' do
    context 'with valid parameters' do
      before do
        post signup_url, params: { user: { email: 'newuser@example.com', password: 'password123', password_confirmation: 'password123', first_name: 'John', last_name: 'Doe' } }, as: :json
      end

      it 'returns a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new user' do
        expect(User.find_by(email: 'newuser@example.com')).to be_present
      end

      it 'returns a JWT token in Authorization header' do
        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to include('Bearer')
      end

      it 'returns success message' do
        json = response.parsed_body
        expect(json['message']).to eq('Signed up successfully.')
      end
    end

    context 'with invalid parameters' do
      before do
        post signup_url, params: { user: { email: '', password: '123', password_confirmation: '456' } }, as: :json
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'does not create user' do
        expect(User.count).to eq(0)
      end

      it 'does not return JWT token' do
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end

  describe 'PATCH /api/v1/users/signup' do
    let(:headers) { authenticate_user(user) }

    context 'when user is authenticated and send valid parameters' do
      before do
        patch update_url, params: { user: { first_name: 'Updated', last_name: 'Name', current_password: 'password123' } }, headers: headers, as: :json
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the user' do
        user.reload
        expect(user.first_name).to eq('Updated')
        expect(user.last_name).to eq('Name')
      end

      it 'returns success message' do
        json = response.parsed_body
        expect(response).to have_http_status(:ok)
        expect(json['message']).to eq('User updated successfully.')
      end
    end

    context 'when user is authenticated and sends invalid parameters' do
      before do
        patch update_url, params: { user: { first_name: '', last_name: '' } }, headers: headers, as: :json
      end

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'does not update user' do
        expect(user.reload.first_name).not_to eq('')
      end

      it 'returns validation errors' do
        json = response.parsed_body
        expect(json['errors']).to be_present
      end
    end

    context 'when user is not authenticated' do
      before do
        patch update_url, params: { user: { first_name: 'Hack', last_name: 'Attempt' } }, as: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

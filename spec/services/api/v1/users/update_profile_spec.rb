# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UpdateProfile do
  let(:password) { 'password123' }
  let(:user) { create(:user, password: password, first_name: 'Old', last_name: 'Name') }

  describe '.call' do
    subject(:result) { described_class.call(user, params) }

    context 'when updating only profile fields' do
      let(:params) do
        {
          first_name: 'New',
          last_name: 'Name'
        }
      end

      it 'updates the user' do
        expect(result.success?).to be true
        expect(result.user.first_name).to eq('New')
        expect(result.user.last_name).to eq('Name')
      end
    end

    context 'when changing password with valid current password' do
      let(:params) do
        {
          current_password: password,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'updates the password' do
        expect(result.success?).to be true
        expect(user.reload.valid_password?('newpassword123')).to be true
      end
    end

    context 'when current password is incorrect' do
      let(:params) do
        {
          current_password: 'wrongpassword',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'fails the update' do
        expect(result.success?).to be false
        expect(result.errors).to include('Current password is incorrect')
      end
    end

    context 'when password confirmation does not match' do
      let(:params) do
        {
          current_password: password,
          password: 'newpassword123',
          password_confirmation: 'different'
        }
      end

      it 'fails the update' do
        expect(result.success?).to be false
        expect(result.errors).to include('Password confirmation does not match')
      end
    end

    context 'when update fails due to validation' do
      let(:params) do
        {
          first_name: ''
        }
      end

      it 'returns failure with model errors' do
        expect(result.success?).to be false
        expect(result.errors).to be_present
      end
    end
  end
end

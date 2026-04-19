# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role).with_values(member: 0, admin: 1, librarian: 2) }
  end

  describe 'defaults' do
    it 'is expected to be enabled by default' do
      expect(user.enabled).to be true
    end

    it 'is expected to have a default role of member' do
      expect(user.member?).to be true
    end
  end

  describe '#full_name' do
    it 'returns the concatenation of first_name and last_name' do
      user = build(:user, first_name: 'Ana', last_name: 'García')
      expect(user.full_name).to eq('Ana García')
    end
  end
end

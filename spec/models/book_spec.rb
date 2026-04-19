# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:genre) }
    it { is_expected.to have_many(:book_copies) }
  end

  describe 'validations' do
    subject { build(:book) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:isbn) }
    it { is_expected.to validate_uniqueness_of(:isbn).case_insensitive }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(inactive: 0, active: 1, archived: 2) }
  end

  describe 'default values' do
    it 'is active by default' do
      expect(described_class.new.active?).to be true
    end
  end
end

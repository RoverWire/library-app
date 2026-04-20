# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookCopy, type: :model do
  subject { build(:book_copy) }

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(available: 0, borrowed: 1, maintenance: 2, lost: 3) }
  end
end

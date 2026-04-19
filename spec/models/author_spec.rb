# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  subject { build(:author) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(%w[Male Female Other]) }
  end

  describe 'invalid gender' do
    it 'is invalid with a non-binary gender not in the list' do
      author = build(:author, gender: 'Robot')
      expect(author).not_to be_valid
    end
  end
end

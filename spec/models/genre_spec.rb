# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Genre, type: :model do
  subject(:genre) { build(:genre) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end

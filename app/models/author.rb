# frozen_string_literal: true

class Author < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :first_name, uniqueness: { scope: :last_name }
  validates :gender, inclusion: { in: %w[Male Female Other] }
end

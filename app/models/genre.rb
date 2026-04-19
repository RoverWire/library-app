# frozen_string_literal: true

class Genre < ApplicationRecord
  has_many :books, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

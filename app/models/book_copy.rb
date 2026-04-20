# frozen_string_literal: true

class BookCopy < ApplicationRecord
  belongs_to :book
  has_many :loans, dependent: :delete_all

  validates :status, presence: true

  enum :status, { available: 0, borrowed: 1, maintenance: 2, lost: 3 }
end

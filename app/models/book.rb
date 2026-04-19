# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :genre
  has_many :book_copies, dependent: :destroy

  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: { case_sensitive: false }
  validates :copies_count, numericality: { greater_than_or_equal_to: 0 }

  enum :status, { inactive: 0, active: 1, archived: 2 }
end

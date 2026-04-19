# frozen_string_literal: true

class BookCopy < ApplicationRecord
  belongs_to :book
  has_many :loans, dependent: :delete_all

  validate :user_can_borrow_only_one_copy, on: :create

  enum :status, { available: 0, borrowed: 1, maintenance: 2, lost: 3 }

  private

  def user_can_borrow_only_one_copy
    return unless user.loans.where(returned_at: nil).exists?

    errors.add(:base, 'You already have an active loan. Please return the current book before borrowing another one.')
  end
end

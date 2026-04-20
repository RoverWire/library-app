# frozen_string_literal: true

class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book_copy

  validate :book_must_be_active, on: :create
  validate :copy_must_be_available, on: :create
  validate :user_limit_one_copy_per_book, on: :create

  before_validation :set_loan_dates, on: :create
  after_create :mark_copy_as_borrowed

  private

  def set_loan_dates
    self.borrowed_at ||= Time.current
    self.due_date ||= 2.weeks.from_now
  end

  def mark_copy_as_borrowed
    book_copy.borrowed!
  end

  def book_must_be_active
    errors.add(:base, 'The book is not active in the catalog') unless book_copy.book.active?
  end

  def copy_must_be_available
    errors.add(:book_copy, 'is not available for loan') unless book_copy.available?
  end

  def user_limit_one_copy_per_book
    existing_loan = user.loans.joins(:book_copy).exists?(returned_at: nil, book_copies: { book_id: book_copy.book_id })

    errors.add(:base, 'You already have a copy of this book') if existing_loan
  end
end

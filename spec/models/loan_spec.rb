# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book, status: :active) }
  let(:copy_one) { create(:book_copy, book: book, status: :available) }
  let(:copy_two) { create(:book_copy, book: book, status: :available) }

  describe 'creation' do
    it 'sets due_date to 14 days from now' do
      loan = create(:loan, user: user, book_copy: copy_one)
      expect(loan.due_date.to_date).to eq(14.days.from_now.to_date)
    end

    it 'changes book_copy status to borrowed' do
      create(:loan, user: user, book_copy: copy_one)
      expect(copy_one.reload.borrowed?).to be true
    end
  end

  describe 'business rules' do
    it 'prevents borrowing a second copy of the same book' do
      create(:loan, user: user, book_copy: copy_one)
      duplicate_loan = build(:loan, user: user, book_copy: copy_two)

      expect(duplicate_loan).not_to be_valid
      expect(duplicate_loan.errors[:base]).to include('You already have a copy of this book')
    end

    it 'prevents borrowing from an inactive book' do
      book.inactive!
      loan = build(:loan, user: user, book_copy: copy_one)
      expect(loan).not_to be_valid
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  let(:user) { create(:user, role: role) }

  let(:own_loan) { create(:loan, user: user) }
  let(:other_loan) { create(:loan) }

  describe 'admin' do
    let(:role) { :admin }

    it 'can manage everything' do
      expect(ability).to be_able_to(:manage, :all)
    end
  end

  describe 'librarian' do
    let(:role) { :librarian }

    let(:loan_not_returned) { create(:loan, returned_at: nil) }
    let(:loan_returned) { create(:loan, returned_at: 1.day.ago) }

    it 'can manage books and related models' do
      expect(ability).to be_able_to(:manage, Book.new)
      expect(ability).to be_able_to(:manage, Author.new)
      expect(ability).to be_able_to(:manage, Genre.new)
      expect(ability).to be_able_to(:manage, BookCopy.new)
    end

    it 'can read loans' do
      expect(ability).to be_able_to(:read, Loan.new)
    end

    it 'can update loan if not returned' do
      expect(ability).to be_able_to(:update, loan_not_returned)
    end

    it 'cannot update returned loan' do
      expect(ability).not_to be_able_to(:update, loan_returned)
    end

    it 'cannot destroy loans' do
      expect(ability).not_to be_able_to(:destroy, Loan.new)
    end
  end

  describe 'member' do
    let(:role) { :member }

    it 'can read catalog' do
      expect(ability).to be_able_to(:read, Book.new)
      expect(ability).to be_able_to(:read, Author.new)
      expect(ability).to be_able_to(:read, Genre.new)
    end

    it 'can create loans' do
      expect(ability).to be_able_to(:create, Loan.new)
    end

    it 'can read own loans' do
      expect(ability).to be_able_to(:read, own_loan)
    end

    it 'cannot read others loans' do
      expect(ability).not_to be_able_to(:read, other_loan)
    end

    it 'can update own loan if not returned' do
      own_loan.update!(returned_at: nil)

      expect(ability).to be_able_to(:update, own_loan)
    end

    it 'cannot update returned loan' do
      own_loan.update!(returned_at: 1.day.ago)

      expect(ability).not_to be_able_to(:update, own_loan)
    end

    it 'cannot update others loans' do
      expect(ability).not_to be_able_to(:update, other_loan)
    end

    it 'returns only own loans for member' do
      own_loan
      other_loan

      results = Loan.accessible_by(ability)

      expect(results).to include(own_loan)
      expect(results).not_to include(other_loan)
    end
  end
end

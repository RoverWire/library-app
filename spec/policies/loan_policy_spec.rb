# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoanPolicy do
  subject(:policy) { described_class.new(user, loan) }

  let(:loan) { create(:loan, returned_at: returned_at, user: owner) }

  let(:owner) { create(:user) }
  let(:user) { create(:user, role: role) }

  describe '#update?' do
    context 'when admin' do
      let(:role) { :admin }
      let(:returned_at) { nil }

      it 'allows update' do
        expect(policy.update?).to be true
      end
    end

    context 'when librarian' do
      let(:role) { :librarian }
      let(:returned_at) { nil }

      it 'allows update' do
        expect(policy.update?).to be true
      end
    end

    context 'when member owns loan' do
      let(:role) { :member }
      let(:owner) { user }
      let(:returned_at) { nil }

      it 'allows update' do
        expect(policy.update?).to be true
      end
    end

    context 'when member does not own loan' do
      let(:role) { :member }
      let(:returned_at) { nil }

      it 'denies update' do
        expect(policy.update?).to be false
      end
    end

    context 'when loan is returned' do
      let(:role) { :admin }
      let(:returned_at) { 1.day.ago }

      it 'denies update' do
        expect(policy.update?).to be false
      end
    end
  end
end

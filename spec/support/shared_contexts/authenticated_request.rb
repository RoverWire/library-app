# frozen_string_literal: true

RSpec.shared_context 'with authenticated request' do |role = :member|
  let(:user) { create(:user, role) }
  let(:headers) { auth_headers(user) }
end

# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    user
    book_copy
    borrowed_at { Time.current }
    due_date { 2.weeks.from_now }
    returned_at { nil }
  end
end

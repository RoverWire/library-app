# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    user
    book_copy
    borrowed_at { Time.current }
    due_date { 2.weeks.from_now }
    returned_at { nil }

    after(:create) do |loan|
      loan.book_copy.update!(status: :borrowed)
    end

    trait :returned do
      returned_at { Time.current }
      after(:create) do |loan|
        loan.book_copy.available!
      end
    end

    trait :overdue do
      borrowed_at { 3.weeks.ago }
      due_date { 1.week.ago }
    end
  end
end

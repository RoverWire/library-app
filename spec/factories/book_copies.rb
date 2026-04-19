# frozen_string_literal: true

FactoryBot.define do
  factory :book_copy do
    status { :available }
    annotations { Faker::Lorem.sentence }
    book

    trait :borrowed do
      status { :borrowed }
    end

    trait :lost do
      status { :lost }
    end

    trait :maintenance do
      status { :maintenance }
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    status { :active }
    description { Faker::Lorem.paragraph }
    copies_count { 0 }
    author
    genre

    trait :with_copies do
      copies_count { 3 }
      book_copies { build_list(:book_copy, 3) }
    end
  end
end

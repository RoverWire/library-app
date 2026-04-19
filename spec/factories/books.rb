# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    status { :active }
    description { Faker::Lorem.paragraph }
    copies_count { 5 }
    author
    genre
  end
end

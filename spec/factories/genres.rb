# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    name { Faker::Book.genre }
  end
end

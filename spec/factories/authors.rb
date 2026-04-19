# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { %w[Male Female Other].sample }
    biography { Faker::Lorem.paragraph }
  end
end

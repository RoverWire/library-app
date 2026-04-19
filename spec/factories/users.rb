# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    enabled { true }
    role { :member }
    created_at { Time.current }
    updated_at { Time.current }

    trait :admin do
      role { :admin }
    end

    trait :librarian do
      role { :librarian }
    end
  end
end

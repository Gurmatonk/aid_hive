FactoryGirl.define do
  factory :user do
    confirmed_at -> { Time.zone.now }
    city 'Stuttgart'
    sequence(:email) { |n| "test_#{n}@example.com" }
    sequence(:name) { |n| "Test User #{n}" }
    password 'please123thisissecure456'
    postal_code '70180'

    trait :admin do
      role 'admin'
    end
  end
end

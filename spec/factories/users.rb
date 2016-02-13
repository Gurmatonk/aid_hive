FactoryGirl.define do
  factory :user do
    confirmed_at -> { Time.zone.now }
    city 'Stuttgart'
    sequence(:email) { |n| "test_#{n}@example.com" }
    sequence(:name) { |n| "Test User #{n}" }
    password 'please123thisissecure456'
    postal_code '70180'

    trait :user do
      role 'user'
    end

    trait :moderator do
      role 'moderator'
    end

    trait :admin do
      role 'admin'
    end

    trait :confirmed do
      after :create do |user, _evaluator|
        user.confirm
      end
    end
  end
end

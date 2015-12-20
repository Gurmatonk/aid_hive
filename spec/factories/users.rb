FactoryGirl.define do
  factory :user do
    confirmed_at -> { Time.zone.now }
    city 'Stuttgart'
    email 'test@example.com'
    name 'Test User'
    password 'please123thisissecure456'
    postal_code '70180'

    trait :admin do
      role 'admin'
    end
  end
end

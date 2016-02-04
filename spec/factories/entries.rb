FactoryGirl.define do
  factory :entry do
    sequence(:title) { |n| "Entry #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    street_name 'Pelargusstraße'
    street_number '1'
    postal_code '70180'
    city 'Stuttgart'
  end
end

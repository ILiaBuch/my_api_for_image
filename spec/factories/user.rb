FactoryGirl.define do
  factory :user do
    sequence(:access_key) { |i| "AC121#{i}" }
  end
end

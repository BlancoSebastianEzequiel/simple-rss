FactoryGirl.define do
  factory :user do
    id 1
    user_name { FFaker::Internet.user_name }
    password "12345678"
    password_confirmation "12345678"
  end
end

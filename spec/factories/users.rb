FactoryBot.define do
  factory :user do
    user_name { FFaker::Internet.user_name }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
  factory :feed do
    url { "https://www.clarin.com/rss/lo-ultimo/" }
    title { "ruby" }
  end
end

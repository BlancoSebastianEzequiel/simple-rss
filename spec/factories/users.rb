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
  factory :article do
    feed_id { 0 }
    link { FFaker::Internet.http_url }
    title { "Ruby 2.7.0-preview1 Released" }
    avatar { FFaker::Avatar.image }
    description { FFaker::Lorem.paragraphs }
  end
  factory :articles_user do
    user { nil }
    article { nil }
    read { false }
  end
  factory :admin_user do
    email { FFaker::Internet.email }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
  factory :folder do
    name { FFaker::Internet.user_name }
  end
  factory :folder_feed_user do
    folder { nil }
    feed { nil }
    user_id { nil }
  end
end

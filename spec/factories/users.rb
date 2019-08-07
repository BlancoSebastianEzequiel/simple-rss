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
    link { "https://www.ruby-lang.org/en/news/2019/05/30/ruby-2-7-0-preview1-released/" }
    title { "Ruby 2.7.0-preview1 Released" }
  end
  factory :articles_user do
    user { nil }
    article { nil }
    read { false }
  end
end

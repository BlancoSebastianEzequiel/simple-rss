class Feed < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :articles
  has_many :folder_feed_user
  has_many :folders, :through => :folder_feed_user

  validates :url, presence: :true, uniqueness: { case_sensitive: true }
  validates_format_of :url, :with => URI::regexp
end

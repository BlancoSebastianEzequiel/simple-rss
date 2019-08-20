class Folder < ApplicationRecord
  has_many :folder_feed_user
  has_many :feeds, :through => :folder_feed_user

  validates :name, presence: :true, uniqueness: { case_sensitive: true }
end

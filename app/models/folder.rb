class Folder < ApplicationRecord
  has_many :folder_feed_user_id
  has_many :feeds, :through => :folder_feed_user_id

  validates :name, presence: :true, uniqueness: { case_sensitive: true }
end

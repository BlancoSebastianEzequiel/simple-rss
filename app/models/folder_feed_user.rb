class FolderFeedUser < ApplicationRecord
  belongs_to :folder
  belongs_to :feed
  self.table_name = "folders_feeds_users"

  validates :user_id, presence: :true
end

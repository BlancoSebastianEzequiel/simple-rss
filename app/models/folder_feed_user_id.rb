class FolderFeedUserId < ApplicationRecord
  belongs_to :folder
  belongs_to :feed

  validates :user_id, presence: :true
end

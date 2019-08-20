class RenameFolderFeedUserIdToFolderFeedUser < ActiveRecord::Migration[5.2]
  def change
    rename_table :folder_feed_user_ids, :folders_feeds_users
    add_index :folders_feeds_users, [:folder_id, :feed_id, :user_id], unique: true
  end
end

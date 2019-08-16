class CreateFolderFeedUserIds < ActiveRecord::Migration[5.2]
  def change
    create_table :folder_feed_user_ids do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :feed, null: false, foreign_key: true
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end

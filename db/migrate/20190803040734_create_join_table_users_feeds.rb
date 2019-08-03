class CreateJoinTableUsersFeeds < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :feeds do |t|
      # t.index [:user_id, :feed_id]
      # t.index [:feed_id, :user_id]
    end
  end
end

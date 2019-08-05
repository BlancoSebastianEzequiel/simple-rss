class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.text :url, null: false
      t.text :title, null: false
      t.timestamps
    end
    add_index :feeds, :url, unique: true
  end
end

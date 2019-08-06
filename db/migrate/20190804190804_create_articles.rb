class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :link, null: false
      t.integer :feed_id, null: false
      t.timestamps
    end
    add_index :articles, :link, unique: true
  end
end

class CreateArticlesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :articles_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end

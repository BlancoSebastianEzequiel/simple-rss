class AddReadToArticlesUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :articles_users, :read, :boolean, default: false
  end
end

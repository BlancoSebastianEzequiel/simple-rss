class AddAvatarAndDescriptionToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :avatar, :string, null: false, default: ""
    add_column :articles, :description, :text, null: false, default: ""
  end
end

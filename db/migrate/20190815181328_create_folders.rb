class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :folders, :name, unique: true
  end
end

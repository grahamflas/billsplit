class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :source, polymorphic: true, null: false
      t.integer :category

      t.timestamps
    end
  end
end

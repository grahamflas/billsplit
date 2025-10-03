class CreateUserEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :user_events do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category

      t.timestamps
    end
  end
end

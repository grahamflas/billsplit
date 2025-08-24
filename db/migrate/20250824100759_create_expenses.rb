class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :reference, null: false

      t.timestamps
    end
  end
end

class CreateSettlements < ActiveRecord::Migration[8.0]
  def change
    create_table :settlements do |t|
      t.references :group, null: false, foreign_key: true
      t.text :note
      t.jsonb :balances

      t.timestamps
    end
  end
end

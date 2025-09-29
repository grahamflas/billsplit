class ChangeExpensesAmountToNumeric < ActiveRecord::Migration[8.0]
  def up
    change_column :expenses, :amount, :numeric, precision: 19, scale: 4, null: false
  end

  def down
    change_column :expenses, :amount, :integer, null: false
  end
end

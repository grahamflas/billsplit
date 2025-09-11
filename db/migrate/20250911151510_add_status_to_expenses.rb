class AddStatusToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :status, :integer, default: 0
  end
end

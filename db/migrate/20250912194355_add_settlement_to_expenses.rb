class AddSettlementToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_reference :expenses, :settlement, null: true, foreign_key: { on_delete: :nullify }
  end
end

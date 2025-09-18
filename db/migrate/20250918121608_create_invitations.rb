class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations do |t|
      t.references :group, null: false, foreign_key: { on_delete: :cascade }
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :invitee, foreign_key: { to_table: :users }
      t.string :invitee_email, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :invitations, [:group_id, :invitee_email], unique: true
  end
end

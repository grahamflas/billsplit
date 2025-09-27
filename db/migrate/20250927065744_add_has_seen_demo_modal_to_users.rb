class AddHasSeenDemoModalToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :has_seen_demo_modal, :boolean, default: false
  end
end

class AddArchivedOnToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :archived_on, :date

    add_index :groups, :archived_on
  end
end

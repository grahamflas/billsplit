class RemoveIndexInvitationsOnGroupIdAndInviteeEmail < ActiveRecord::Migration[8.0]
  def change
    remove_index :invitations, name: "index_invitations_on_group_id_and_invitee_email"
  end
end

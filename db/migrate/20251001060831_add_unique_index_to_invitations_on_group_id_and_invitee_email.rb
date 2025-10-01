class AddUniqueIndexToInvitationsOnGroupIdAndInviteeEmail < ActiveRecord::Migration[8.0]
  def change
    add_index :invitations,
      [ :invitee_email, :group_id ],
      unique: true,
      where: "status = 0",
      name: "index_invitations_on_invitee_email_and_group_id_pending"
  end
end

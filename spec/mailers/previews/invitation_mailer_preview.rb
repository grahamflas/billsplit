# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/invitation_mailer/invitation_for_non_user_email
  def invitation_for_non_user_email
    group = FactoryBot.build(:group)
    creator = FactoryBot.build(:user, groups: [ group ])
    invitee_email = "future-billsplit-member@mail.com"

    InvitationMailer.with(
      creator:,
      invitee_email:,
      group:,
    ).invitation_for_non_user_email
  end
end

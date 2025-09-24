class InvitationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invitation_for_non_user_email.subject
  #
  def invitation_for_non_user_email
    @creator = params[:creator]
    @invitee_email = params[:invitee_email]
    @group = params[:group]

    mail to: @invitee_email, subject: "You've been invited to BillSplit!"
  end
end

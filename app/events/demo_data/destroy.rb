module DemoData
  class Destroy
    def initialize(user:)
      @user = user
    end

    def process
      ApplicationRecord.transaction do
        demo_groups.each do |group|
          expenses = Expense.where(group:)

          settlements = Settlement.where(group:)

          invitations = Invitation.where(group:)

          notifications = Notification.where(
            source: [
              expenses,
              settlements,
              invitations,
            ].flatten
          )

          memberships = Membership.where(group:)

          [
            notifications,
            expenses,
            settlements,
            invitations,
            memberships,
          ].each do |collection|
            collection.each(&:destroy)
          end

          group.destroy
        end

        demo_users = User.where(
          "email ILIKE ?",
          "%#{user.email_prefix}-demo-%"
        )

        demo_users.each(&:destroy)
      end
    end

    private

    attr_reader :user

    def demo_groups
      user.groups.where(
        demo: true,
      )
    end
  end
end

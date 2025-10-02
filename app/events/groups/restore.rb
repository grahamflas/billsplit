module Groups
  class Restore
    def initialize(group:)
      @group = group
    end

    def process
      if group.archived?
        ApplicationRecord.transaction do
          group.restore

          notify_group_members
        end

        group
      end
    end

    private

    attr_reader :group

    def notify_group_members
      group_members.each do |user|
        Notification.create!(
          user:,
          source: group,
          category: :group_restored,
        )
      end
    end

    def group_members
      group.users
    end
  end
end

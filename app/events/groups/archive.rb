module Groups
  class Archive
    def initialize(group:)
      @group = group
    end

    def process
      if group.active?
        ApplicationRecord.transaction do
          group.archive

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
          category: :group_archived,
        )
      end
    end

    def group_members
      group.users
    end
  end
end

require "rails_helper"

describe Groups::Restore do
  describe "process" do
    it "restores the archived group and creates a notification for each group member" do
      group = create(:group, :archived)

      user_1 = create(:user, groups: [ group ])
      user_2 = create(:user, groups: [ group ])
      user_3 = create(:user, groups: [ group ])

      Groups::Restore.new(group:).process

      expect(group.reload.archived?).to eq(false)

      [user_1, user_2, user_3].each do |user|
        expect(
          Notification.find_by(
            user:,
            source: group,
            category: :group_restored
          )
        ).to be_present, "No group restored notification for #{user}"
      end
    end

    context "when the group is already active" do
      it "no-ops" do
        group = create(:group, :archived)

        create(:user, groups: [ group ])
        create(:user, groups: [ group ])
        create(:user, groups: [ group ])

        Groups::Restore.new(group:).process

        expect(Notification.count).to eq(3)

        second_result = Groups::Restore.new(group:).process

        expect(second_result).to be_nil

        expect(Notification.count).to eq(3)
      end
    end
  end
end

require "rails_helper"

describe Groups::Archive do
  describe "process" do
    it "archives the group and creates a notification for each group member" do
      group = create(:group)

      user_1 = create(:user, groups: [ group ])
      user_2 = create(:user, groups: [ group ])
      user_3 = create(:user, groups: [ group ])

      Groups::Archive.new(group:).process

      expect(group.reload.archived?).to eq(true)

      [user_1, user_2, user_3].each do |user|
        expect(
          Notification.find_by(
            user:,
            source: group,
            category: :group_archived
          )
        ).to be_present, "No group archived notification for #{user}"
      end
    end

    context "when the group is already archived" do
      it "no-ops" do
        group = create(:group)

        create(:user, groups: [ group ])
        create(:user, groups: [ group ])
        create(:user, groups: [ group ])

        Groups::Archive.new(group:).process

        expect(Notification.count).to eq(3)

        second_result = Groups::Archive.new(group:).process

        expect(second_result).to be_nil

        expect(Notification.count).to eq(3)
      end
    end
  end
end

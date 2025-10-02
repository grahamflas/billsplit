require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "associations" do
    it { should have_many(:memberships) }
    it { should have_many(:users).through(:memberships) }
    it { should have_many(:expenses) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "scopes" do
    describe "active" do
      it "only returns active groups" do
        active_group_1 = create(:group)
        active_group_2 = create(:group)

        archived_group_1 = create(:group, :archived)
        archived_group_2 = create(:group, :archived)

        expect(Group.active).to include(
          active_group_1, active_group_2
        )

        expect(Group.active).not_to include(
          archived_group_1, archived_group_2
        )
      end
    end

    describe "archived" do
      it "only returns archived groups" do
        active_group_1 = create(:group)
        active_group_2 = create(:group)

        archived_group_1 = create(:group, :archived)
        archived_group_2 = create(:group, :archived)

        expect(Group.archived).to include(
          archived_group_1, archived_group_2
        )

        expect(Group.archived).not_to include(
          active_group_1, active_group_2
        )
      end
    end
  end

  describe "#archive" do
    it "should set the archived_on to the current date" do
      group = create(:group)

      group.archive

      expect(group.reload.archived_on).not_to be_nil
      expect(group.archived_on.class).to be(Date)
    end
  end

  describe "#restore" do
    it "should set the archived_on to nil" do
      group = create(:group, archived_on: Time.now)

      group.restore

      expect(group.reload.archived_on).to be_nil
    end
  end
end

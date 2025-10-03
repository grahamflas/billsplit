require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:memberships) }
    it { should have_many(:groups).through(:memberships) }
    it { should have_many(:expenses) }
  end

  describe "#full_name" do
    it "returns the user's first and last name" do
      user = create(
        :user,
        first_name: "Liz",
        last_name: "Lemon",
      )

      expect(user.full_name).to eq("Liz Lemon")
    end
  end

  describe "email_prefix" do
    it "returns the part of the user's email before the @" do
      user = create(
        :user,
        email: "prefix@mail.com",
      )

      expect(user.email_prefix).to eq("prefix")
    end
  end

  describe "email_domain" do
    it "returns the part of the user's email after the @" do
      user = create(
        :user,
        email: "prefix@mail.com",
      )

      other_user = create(
        :user,
        email: "username@sub.domain.co.uk",
      )

      expect(user.email_domain).to eq("mail.com")
      expect(other_user.email_domain).to eq("sub.domain.co.uk")
    end
  end

  describe "#destroy_demo_data" do
    it "destroys the demo data created for the user on sign up", :aggregate_failures do
      new_user = create(:user)

      DemoData::Create.new(new_user:).process

      new_user.received_invitations.first.accept

      demo_group_1, demo_group_2 = new_user.groups.where(demo: true)

      new_user.destroy_demo_data

      [demo_group_1, demo_group_2].each do |group|
        expect(
          Expense.where(group:)
        ).to be_empty, "Found Expense for #{group.name}"

        expect(
          Settlement.where(group:)
        ).to be_empty, "Found Settlement for #{group.name}"

        expect(
          Invitation.where(group:)
        ).to be_empty, "Found Invitation for #{group.name}"

        expect(
          Group.find_by(id: group.id)
        ).to be_nil, "Found Group #{group.name}, id: #{group.id}"
      end

      expect(
        User.where(
          "email ILIKE ?",
          "%#{new_user.email_prefix}-demo-%"
        )
      ).to be_empty
    end
  end

  describe "#log_event" do
    it "creates a UserEvent for the given event_type" do
      user = create(:user)

      user.log_event(:sign_up)
      user.log_event(:log_in)

      expect(
        UserEvent.find_by(
          category: :sign_up,
          user:,
        )
      ).to be_present

      expect(
        UserEvent.find_by(
          category: :log_in,
          user:,
        )
      ).to be_present
    end
  end
end

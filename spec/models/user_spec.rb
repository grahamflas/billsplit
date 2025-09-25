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
end

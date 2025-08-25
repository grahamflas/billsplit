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
end

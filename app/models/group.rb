class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  has_many :expenses
  has_many :settlements
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
end

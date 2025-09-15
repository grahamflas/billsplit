class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  has_many :expenses
  has_many :settlements

  validates :name, presence: true
end

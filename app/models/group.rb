class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  has_many :expenses
  has_many :settlements
  has_many :invitations, dependent: :destroy

  validates :name, presence: true

  scope :active, -> { where(archived_on: nil) }

  scope :archived, -> { where.not(archived_on: nil) }

  def archive
    update!(archived_on: Time.now)
  end

  def restore
    update!(archived_on: nil)
  end
end

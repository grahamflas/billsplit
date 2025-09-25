class Expense < ApplicationRecord
  MUST_BELONG_TO_SELECTED_GROUP_ERROR = "must belong to the selected group".freeze

  belongs_to :user
  belongs_to :group
  belongs_to :settlement, optional: true

  has_many :notifications, as: :source

  validates :reference, presence: true
  validates :amount, numericality: true

  validate :user_must_be_group_member

  enum :status, {
    open: 0,
    settled: 1,
    deleted: 2,
  }

  def user_must_be_group_member
    unless user.groups.include?(group)
      errors.add(:user, MUST_BELONG_TO_SELECTED_GROUP_ERROR)
    end
  end

  def notify_other_group_users(current_user:)
    category = if previously_new_record?
      :expense_added
    else
      :expense_updated
    end

    group.
      users.
      where.not(id: current_user.id).
      each do |user|
        Notification.create!(
          user:,
          source: self,
          category:,
        )
      end
  end

end

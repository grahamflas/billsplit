class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  enum :category, {
    expense_added: 0,
    expense_updated: 1,
    settlement_created: 2,
    invitation_created: 3,
  }
end

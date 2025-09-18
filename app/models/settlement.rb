class Settlement < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :expenses
  has_many :notifications, as: :source
end

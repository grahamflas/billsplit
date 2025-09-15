class SettlementSerializer < ApplicationSerializer
  belongs_to :user
  belongs_to :group
  has_many :expenses

  attributes(:id, :note, :balances, :created_at)
end

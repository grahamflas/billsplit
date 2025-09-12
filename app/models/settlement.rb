class Settlement < ApplicationRecord
  belongs_to :group
  has_many :expenses
end

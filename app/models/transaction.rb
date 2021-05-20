class Transaction < ApplicationRecord
  ACTIVITY = %w[deposit withdraw]

  belongs_to :wallet

  validates :activity, inclusion: { in: ACTIVITY }
  validates :amount, presence: true, numericality: { only_integer: true }
end

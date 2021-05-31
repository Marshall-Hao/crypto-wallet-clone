class Transaction < ApplicationRecord
  ACTIVITY = %w[deposit withdraw transfer receive]
  OPTIONS = %w[deposit withdraw transfer]

  belongs_to :wallet

  validates :activity, inclusion: { in: ACTIVITY }
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def deposit_money
    "#{activity} #{amount}"
  end

  def withdraw_money
    "#{activity} #{amount}"
  end
end

class ChangeDefaultBalanceToWallets < ActiveRecord::Migration[6.0]
  def change
    change_column :wallets, :balance, :integer, :default => 0
  end
end

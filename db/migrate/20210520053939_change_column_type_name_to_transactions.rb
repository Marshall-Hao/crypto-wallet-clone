class ChangeColumnTypeNameToTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :type, :activity
  end
end

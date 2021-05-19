class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :type
      t.integer :amount
      t.string :sender_email
      t.string :receiver_email
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end

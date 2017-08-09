class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :category
      t.belongs_to :account, index: true

      t.timestamps
    end
  end
end

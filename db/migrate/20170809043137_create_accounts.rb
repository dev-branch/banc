class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :category
      t.decimal :balance
      t.boolean :is_suspended, default: false
      t.boolean :is_closed, default: false

      t.timestamps
    end
  end
end

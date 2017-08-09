class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :category, null: false
      t.decimal :balance, default: 0, null: false
      t.integer :flags, default: 0, null: false
      t.boolean :is_suspended, default: false, null: false
      t.boolean :is_closed, default: false, null: false

      t.timestamps
    end
  end
end

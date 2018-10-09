class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :token

      t.timestamps
    end

    add_index :customers, :email
    add_index :customers, :token, unique: true
  end
end

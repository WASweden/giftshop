class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string   :payment_type,     default: 'card'
      t.string   :stripe_charge_id
      t.datetime :paid_at
      t.integer  :total

      t.timestamps
    end

    add_index :orders, :payment_type
  end
end

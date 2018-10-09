class SwishPaymentStatus < ActiveRecord::Migration
  def change
    create_table :swish_payments do |t|
      t.string :payment_id, null: false
      t.jsonb :info, null: false, default: {}
      t.references :order, foreign_key: true, index: true, null: false

      t.timestamps(null: false)
    end
  end
end

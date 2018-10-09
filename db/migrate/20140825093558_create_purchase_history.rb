class CreatePurchaseHistory < ActiveRecord::Migration
  def change
    create_table :purchase_histories do |t|
      t.string :donor
      t.string :token, null: false

      t.timestamps
    end
  end
end

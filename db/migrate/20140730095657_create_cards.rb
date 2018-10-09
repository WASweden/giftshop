class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :order

      t.string   :type
      t.text     :text
      t.string   :from
      t.string   :image
      t.integer  :quantity
      t.string   :receiver
      t.boolean  :send_to_donor, default: false
      t.boolean  :hide_amount,   default: false
      t.datetime :send_at
      t.datetime :sent_at
      t.string   :token,         null: false

      t.timestamps
    end

    add_index :cards, :type
    add_index :cards, :send_to_donor
    add_index :cards, :token, unique: true
  end
end

class CreateGiftcards < ActiveRecord::Migration
  def change
    create_table :giftcards do |t|
      t.string   :name
      t.text     :description
      t.string   :category
      t.string   :in_which_store
      t.integer  :amount
      t.timestamps null: false
    end
  end
end

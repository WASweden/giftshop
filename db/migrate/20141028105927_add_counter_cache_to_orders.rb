class AddCounterCacheToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :digital_cards_count, :integer, default: 0
  	add_column :orders, :analog_cards_count,  :integer, default: 0

  	add_index :orders, :digital_cards_count
  	add_index :orders, :analog_cards_count
  end
end

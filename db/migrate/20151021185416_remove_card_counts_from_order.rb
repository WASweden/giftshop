class RemoveCardCountsFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :digital_cards_count
    remove_column :orders, :analog_cards_count
    remove_column :orders, :order_id
  end
end

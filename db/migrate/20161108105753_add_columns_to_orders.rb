class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :analog_cards_regular_count, :integer, default: 0
    add_column :orders, :analog_cards_xmas_count, :integer, default: 0
  end
end

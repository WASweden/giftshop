class AddCardCountsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :digital_cards_count, :integer, default: 0
    add_column :orders, :analog_cards_count, :integer, default: 0
  end
end

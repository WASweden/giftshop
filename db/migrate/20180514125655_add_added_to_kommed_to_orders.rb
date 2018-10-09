class AddAddedToKommedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :added_to_kommed, :boolean, null: false, default: false
  end
end

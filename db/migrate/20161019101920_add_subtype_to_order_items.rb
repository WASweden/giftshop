class AddSubtypeToOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :subtype, :string, default: nil

    OrderItem.update_all subtype: "regular"
  end

  def down
    remove_column :order_items, :subtype
  end
end

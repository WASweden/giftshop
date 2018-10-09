class AddOrderId < ActiveRecord::Migration
  def change
    add_column :orders, :order_id, :integer

    Order.completed.each do |order|
      order.order_id = order.id
      order.save!(validate: false)
    end
  end
end

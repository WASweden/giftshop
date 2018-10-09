namespace :orders do

  desc "Update order card counts"
  task :update_card_counts => :environment do
    Order.find_each do |order|
      printf "."
      order.update_card_counts!
    end
  end

  desc "Convert order items to cards"
  task :convert_items_to_cards => :environment do
    Order.find_each do |order|
      if order.total_card_count > 0 && order.donor.present? && order.cards.blank?
        puts "Order id: #{order.id}"

        order.order_items.each do |order_item|
          order_item.convert_to_cards
        end
      end
    end
  end

  desc "Set order_id"
  task :set_swish_payment_order_id => :environment do
    Order.completed.each do |order|
      if order.swish_payment
        order.update(
          order_id: Order.completed.maximum(:order_id) ? Order.completed.maximum(:order_id) + 1 : 1
        )
      end
    end
  end
end

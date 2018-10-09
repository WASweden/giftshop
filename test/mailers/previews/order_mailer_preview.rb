class OrderMailerPreview < ActionMailer::Preview
  def receipt
    OrderMailer.receipt(Order.completed.last.id)
  end

  def confirmation
    OrderMailer.confirmation(Order.completed.last.id)
  end

  def card
    order = Order.completed.last
    OrderMailer.card(order.cards.first.id)
  end

  def card_confirmation
    order = Order.completed.last
    OrderMailer.card_confirmation(order.cards.first.id)
  end

  def invoice_purchase_alert
    order = Order.completed.last
    OrderMailer.invoice_purchase_alert(Order.completed.last.id)
  end

  def xmas_bundle
    order = Order.create!
    Donor.find_by(donor_type: "company").update! order: order
    order.order_items << OrderItem.create!(product: "DigitalCard", subtype: "xmas", quantity: 100, product_quantity: 100)

    OrderMailer.xmas_bundle(order.id)
  end
end

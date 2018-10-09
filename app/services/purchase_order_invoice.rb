class PurchaseOrderInvoice
  attr_reader :errors

  def self.call(order)
    new(order).call
  end

  def initialize(order)
    @errors = []
    @order = order
  end

  def call
    invoice_charge()

    if @errors.empty? && @order.save
      OrderMailer.delay.confirmation(@order.id)
      OrderMailer.delay.invoice_purchase_alert(@order.id)
      true
    end
  end

  private

  def invoice_charge
    @order.update(
      total: @order.calculate_total,
      paid_at: Time.zone.now,
      order_id: Order.completed.maximum(:order_id) ? Order.completed.maximum(:order_id) + 1 : 1,
    )
  end
end

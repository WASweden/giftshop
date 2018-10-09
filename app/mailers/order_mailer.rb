class OrderMailer < ActionMailer::Base
  helper :application

  def receipt(order_id)
    @order = Order.find(order_id)

    # return if @order.stripe_charge_id.nil?

    @stripe_charge = Stripe::Charge.retrieve(@order.stripe_charge_id)

    mail(to: @order.donor.email, subject: 'Kvitto från WaterAid Gåvoshop')

  rescue ActiveRecord::RecordNotFound
    # Do nothing
  end

  def confirmation(order_id)
    @order = Order.find(order_id)

    if @order.donor.donor_type == 'company'
      subject = 'Tack för er beställning från WaterAids gåvoshop'
    else
      subject = 'Tack för din beställning från WaterAids gåvoshop'
      # attachments['WaterAid_gavobevis_A5.pdf'] = File.read("#{Rails.root}/public/WaterAid_gavobevis_A5.pdf")
    end

    mail(to: @order.donor.email, subject: subject)
  end

  def analog_card_order(order_id, order_url)
    @order = Order.find(order_id)
    @order_url = order_url

    if @order.try(:donor).try(:donor_type) == "company"
      email_address = "infocorporate@wateraid.se"
    else
      email_address = "info@wateraid.se"
    end

    mail(to: email_address, subject: 'Tryckt gåvobevis beställt i gåvoshopen')
  end

  def card(card_id)
    @card = Card.find(card_id)
    @order = Order.find(@card.order_id)

    if @card.send_to_donor == true && @order.donor.donor_type == 'company'
      subject = 'Ert digitala gåvobevis från WaterAid'
    elsif @card.send_to_donor == true
      subject = 'Ditt digitala gåvobevis från WaterAid'
    elsif @order.donor.donor_type == 'company'
      subject = "En present från #{@order.donor.company}"
    elsif @order.payment_type != 'sms'
      subject = "En present från #{@order.donor.first_name}"
    else
      subject = "Du har fått en present från en vän"
    end

    mail(to: @card.receiver, subject: subject)
  end

  def card_confirmation(card_id)
    @card = Card.find(card_id)
    @order = Order.find(@card.order_id)

    subject = 'Gåvobeviset från WaterAid har nu skickats'

    mail(to: @card.order.donor.email, subject: subject) unless @card.send_to_donor?
  end

  def invoice_purchase_alert(order_id)
    @order = Order.find(order_id)

    mail(to: 'infocorporate@wateraid.se', subject: "Gåva mot rekvisition på WaterAid Gåvoshop [OrderID: #{@order.id}]")
  end
end

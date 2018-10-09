class CardWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :card

  def perform(card_id)
    card = Card.find(card_id)

    return unless card.ready_to_be_sent?

    card.update_attribute(:sent_at, Time.zone.now)

    OrderMailer.delay.card(card.id)
    OrderMailer.delay.card_confirmation(card.id) unless card.order.payment_type == "sms"
  end
end

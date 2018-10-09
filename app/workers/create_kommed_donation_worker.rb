class CreateKommedDonationWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    donation = Donation.new(order)

    donation_service = CreateKommedDonation.new(donation)
    donation_service.perform
  end
end

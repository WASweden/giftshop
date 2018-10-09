class CreateKommedDonation
  attr_accessor :donation, :client

  def initialize(donation, config = {})
    @donation = donation
    @client = Savon.client(wsdl: config[:wsdl] || wsdl)
  end

  def perform
    return true unless Rails.application.secrets.ping_kommed

    response = client.call(:add_payment, message: donation.params)

    if response.body[:add_payment_response][:result] == "OK"
      order = donation.order

      order.added_to_kommed = true
      order.save
    end

    response
  end

  private

  def wsdl
    # "https://demo.kommed.se/ws/kommed_ws.php?wsdl"
    "https://#{Kommed.client_id}.kommed.se/ws/kommed_ws.php?wsdl"
  end
end

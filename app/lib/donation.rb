class Donation
  attr_accessor :order, :donor

  def initialize(order)
    @order = order
    @donor = order.donor
  end

  def params
    result = {
      "firstname" => donor.first_name,
      "middlename" => "",
      "lastname" => donor.last_name,
      "title" => "",
      "company" => donor.company,
      "department" => "",
      "birth_date" => "",
      "social_id" => "",
      "co" => "",
      "address" => donor.address,
      "extra_address" => "",
      "zip" => donor.post_code,
      "city" => donor.city,
      "country_id" => 46,
      "email" => donor.email,
      "phone" => "",
      "fax" => "",
      "mobile" => donor.phone,
      "amount" => order.total,
      "pledge_target" => 50
    }

    # Printed card, card payment: 986
    # Digital card, card payment: 987
    #
    # Printed card, Swish payment: 1018
    # Digital card, Swish payment: 1019
    case order.payment_type
    when "swish"
      result.merge!({
        "campaign_id" => (order.has_analog_cards? ? 1018 : 1019),
        "payment_id1" => "",
        "payment_id2" => "",
        "paid_with" => 25,
      })
    when "card"
      result.merge!({
        "campaign_id" => (order.has_analog_cards? ? 986 : 987),
        "payment_id1" => "",
        "payment_id2" => "",
        "paid_with" => 9,
      })
    when "invoice"
      result.merge!({
        "campaign_id" => 797,
        "payment_id1" => "",
        "payment_id2" => "",
        "paid_with" => -1,
      })
    end

    result
  end
end

# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  order_id      :integer
#  type          :string(255)
#  text          :text
#  quantity      :integer
#  receiver      :string(255)
#  send_to_donor :boolean          default(FALSE)
#  send_at       :datetime
#  sent_at       :datetime
#  token         :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#  form_type     :string(255)
#  job_id        :string(255)
#  subtype       :string
#

class AnalogCard < Card
  def price
    (quantity * DROPLET_PRICE) + PRINTED_PRICE
  end

  private

  def defaults
    super

    # Analog cards are always sent to the donor
    self.send_to_donor = true
  end
end

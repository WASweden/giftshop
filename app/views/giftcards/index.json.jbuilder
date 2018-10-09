json.array!(@giftcards) do |giftcard|
  json.extract! giftcard, :id
  json.url giftcard_url(giftcard, format: :json)
end

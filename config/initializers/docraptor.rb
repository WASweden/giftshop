DocRaptor.configure do |dr|
  dr.username = Rails.application.secrets.docraptor_api_key
  # dr.debugging = !Rails.env.production?
end

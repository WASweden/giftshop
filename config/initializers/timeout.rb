if Rails.env.production? || Rails.env.staging?
  Rack::Timeout.timeout = 20 # seconds
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: Rails.application.secrets.sidekiq_redis_url
  }
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end

  database_url = ENV['DATABASE_URL']
  if database_url
    ENV['DATABASE_URL'] = "#{database_url}?pool=25"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: Rails.application.secrets.sidekiq_redis_url
  }
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

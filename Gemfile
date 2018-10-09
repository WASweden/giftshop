source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use postgresql as the database for Active Record
gem 'pg', '0.20.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'compass-rails', '~> 2.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'activeadmin', '~> 1.0.0.pre2'
gem 'devise', '~> 3.4.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'rollbar'
gem 'sinatra', '~> 1.4.5'
gem 'sidekiq', '~> 3.2.5'
gem 'sidekiq-status', '~> 0.5.1'
gem 'active_model_serializers', '~> 0.8.1'
gem 'rack-cors', '~> 0.2.9', require: 'rack/cors'
gem 'formtastic', '~> 3.1.0'
gem 'i18n_country_select', '~> 1.1.4'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'carrierwave', '~> 0.10.0'
gem 'cloudinary', '~> 1.0.77'
gem 'responders', '~> 2.0'
gem 'mixpanel-ruby', '~> 1.5.0'
gem 'puma'
gem 'newrelic_rpm'
gem 'font-awesome-rails', '~> 4.2.0.0'
gem 'docraptor', '~> 1.0.0'

group :production, :staging do
  gem 'rails_12factor'
  gem 'rack-timeout'
end

group :development do
  gem 'annotate'
  gem 'rails-erd'
  gem 'figaro'
  gem 'rb-readline'
  gem 'web-console', '~> 2.0'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '3.7.2'
  gem 'factory_girl_rails'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-collection_matchers'
  gem 'database_cleaner'
  gem 'faker'
  gem 'capybara'
  gem 'poltergeist'
  gem 'webmock'
end

gem 'kommed', source: 'https://xXTjctEsJseqMrC-5mbZ@repo.fury.io/kollegorna/'
# gem 'httparty', '~> 0.16.0'
gem 'faraday'
gem 'faraday_middleware'
gem "js-routes"
gem 'savon', '~> 2.12.0'

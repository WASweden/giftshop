if Rails.env.production? || Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => Rails.application.secrets.sendgrid_username,
    :password       => Rails.application.secrets.sendgrid_password,
    :domain         => 'wateraid.se'
  }
  ActionMailer::Base.delivery_method = :smtp
end

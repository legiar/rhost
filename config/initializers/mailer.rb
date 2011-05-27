RHost::Application.configure do
  config.action_mailer.default_url_options = {
    :protocol => "http",
    :host => "mars.bpmonline.com:3000"
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => "mail.tscrm.com",
    :authentication => false,
    :enable_starttls_auto => false
  }
end

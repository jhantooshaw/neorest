# Be sure to restart your server when you modify this file.
case Rails.env
when "production"
  Rails.application.config.session_store :cookie_store, key: '_neo_rest_session'
when "staging"
  Rails.application.config.session_store :cookie_store, key: '_neo_rest_session'
else
  Rails.application.config.session_store :cookie_store, key: '_neo_rest_session', :domain => :all
end

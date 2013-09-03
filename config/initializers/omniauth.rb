# -*- encoding : utf-8 -*-
Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :open_id,
           :identifier => 'https://www.google.com/accounts/o8/id'
end

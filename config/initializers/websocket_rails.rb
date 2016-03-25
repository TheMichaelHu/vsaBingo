WebsocketRails.setup do |config|
  config.log_internal_events = true
  config.standalone = true
  if Rails.env.production?
    config.redis_options = {:host => 'tarpon.redistogo.com', :port => '10810', :user => 'redistogo', :password => '222473d9cfb996ef1feb29257334f40b'}
  else
    config.redis_options = {:host => 'localhost', :port => '6379'}
  end
end

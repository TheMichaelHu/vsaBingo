WebsocketRails.setup do |config|
  config.standalone = true
  config.redis_options = {:host => 'tarpon.redistogo.com', :port => '10810', :user => 'redistogo', :password => '222473d9cfb996ef1feb29257334f40b'}
end

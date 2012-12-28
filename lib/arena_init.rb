Arena.configure do |config|
  config.application_id = ENV['APPLICATION_ID']
  config.application_secret = ENV['APPLICATION_SECRET']
  config.access_token = ENV['ACCESS_TOKEN']
end

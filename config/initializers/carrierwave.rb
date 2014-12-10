if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'us-west-1'
    }
    config.fog_public = true
    config.fog_directory = ENV['AWS_BUCKET']
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}
    config.storage = :fog
  end
end
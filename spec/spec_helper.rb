require 'rack/test'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

ActiveRecord::Base.logger = nil

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
  config.order = 'random'
  config.color = true

  config.include EndpointHelper, type: :api
end

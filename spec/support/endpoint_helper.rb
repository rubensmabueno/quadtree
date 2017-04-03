# frozen_string_literal: true
module EndpointHelper
  include Rack::Test::Methods

  def app
    Spotippos::API
  end
end

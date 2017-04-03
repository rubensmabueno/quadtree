module Spotippos
  class API < Grape::API
    prefix 'api'
    format :json

    add_swagger_documentation api_version: 'v1'
  end
end

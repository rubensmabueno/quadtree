module Spotippos
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    mount Spotippos::PropertiesResource

    add_swagger_documentation api_version: 'v1'
  end
end

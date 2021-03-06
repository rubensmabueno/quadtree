require 'roar/json'

module Spotippos
  module PropertyRepresenter
    include Roar::JSON
    include Grape::Roar::Representer

    property :id
    property :x
    property :y
    property :title
    property :price
    property :description
    property :beds
    property :baths
    property :square_meters, as: :squareMeters
    property :provinces_name, as: :provinces, exec_context: :decorator

    def provinces_name
      provinces.map(&:name)
    end
  end
end

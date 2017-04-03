require 'roar/json'
require 'representers/property_representer'

module Spotippos
  module PropertyCollectionRepresenter
    include Roar::JSON
    include Grape::Roar::Representer

    property :count, as: :foundProperties
    collection :entries, extend: ::Spotippos::PropertyRepresenter, as: :properties
  end
end

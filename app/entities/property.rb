module Spotippos
  class Property
    include ActAsPoint

    attr_accessor :id, :x, :y, :title, :price, :description, :beds, :baths, :square_meters

    def initialize(id: nil, x:, y:, title:, price:, description:, beds:, baths:, square_meters:)
      self.id = id
      self.x = x
      self.y = y
      self.title = title
      self.price = price
      self.description = description
      self.beds = beds
      self.baths = baths
      self.title = title
      self.square_meters = square_meters
    end

    def provinces
      Spotippos::Kingdom.find_province(self)
    end

    def save
      return @saved if @saved

      self.class.add(self)

      @saved = true
    end

    def self.repository
      @repository ||= {}
    end

    def self.add(property)
      property.id ||= repository.length + 1
      repository[property.id.to_s] = property
      property
    end

    def self.[](id)
      repository[id.to_s]
    end

    def self.clean_all
      @repository = {}
    end
  end
end

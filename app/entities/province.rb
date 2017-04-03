module Spotippos
  class Province
    include ActAsRectangle

    attr_accessor :name, :upper_left, :bottom_right

    def initialize(name:, upper_left:, bottom_right:)
      self.name = name
      self.upper_left = upper_left
      self.bottom_right = bottom_right
    end

    def save
      return @saved if @saved

      self.class.add(self)

      @saved = true
    end

    def self.repository
      @repository ||= {}
    end

    def self.add(province)
      province.id ||= repository.length + 1
      repository[province.id.to_s] = province
      province
    end

    def self.[](id)
      repository[id.to_s]
    end

    def self.clean_all
      @repository = {}
    end
  end
end

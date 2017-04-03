module Spotippos
  class Province
    include ActAsRectangle

    attr_accessor :name, :upper_left, :bottom_right

    def initialize(name = nil, upper_left = nil, bottom_right = nil)
      self.name = name
      self.upper_left = upper_left
      self.bottom_right = bottom_right
    end

    def self.all
      @provinces ||= JSON.parse(File.read(File.expand_path('../../../provinces.json', __FILE__))).map do |name, attributes|
        new(
          name,
          Quadtree::Point.new(
            attributes['boundaries']['upperLeft']['x'],
            attributes['boundaries']['upperLeft']['y']
          ),
          Quadtree::Point.new(
            attributes['boundaries']['bottomRight']['x'],
            attributes['boundaries']['bottomRight']['y']
          )
        )
      end
    end
  end
end

require 'entities/province'
require 'lib/quadtree/point'
require 'lib/quadtree/rectangle'
require 'lib/quadtree/quarter'

module Spotippos
  class Kingdom
    class << self
      def find_province(property)
        quadtree.add_point(property).areas
      end

      def find_properties(rectangle)
        quadtree.find_area(rectangle).map(&:points).flatten
      end

      def add_property(property)
        quadtree.add_point(property)
      end

      def properties
        @properties ||= JSON.parse(File.read(properties_file))['properties'].map do |attributes|
          Property.new(
            id: attributes['id'],
            title: attributes['title'],
            price: attributes['price'],
            description: attributes['description'],
            x: attributes['lat'],
            y: attributes['long'],
            beds: attributes['beds'],
            baths: attributes['baths'],
            square_meters: attributes['squareMeters']
          )
        end
      end

      def provinces
        @provinces ||= JSON.parse(File.read(provinces_file)).map do |name, attributes|
          Province.new(
            name: name,
            upper_left: Quadtree::Point.new(
              attributes['boundaries']['upperLeft']['x'],
              attributes['boundaries']['upperLeft']['y']
            ),
            bottom_right: Quadtree::Point.new(
              attributes['boundaries']['bottomRight']['x'],
              attributes['boundaries']['bottomRight']['y']
            )
          )
        end
      end

      private

      def quadtree
        @quadtree ||= Quadtree::Quarter.new(upper_left, bottom_right, provinces)
      end

      # Take the province at the most top left to be a reference for the quarter
      def upper_left
        @upper_left ||= Quadtree::Point.new(
          provinces.map { |province| province.upper_left.x }.min,
          provinces.map { |province| province.upper_left.y }.max
        )
      end

      # Take the province at the most bottom right to be a reference for the quarter
      def bottom_right
        @bottom_right ||= Quadtree::Point.new(
          provinces.map { |province| province.bottom_right.x }.max,
          provinces.map { |province| province.bottom_right.y }.min
        )
      end

      def properties_file
        @properties_file ||= File.expand_path('../../../properties.json', __FILE__)
      end

      def provinces_file
        @provinces_file ||= File.expand_path('../../../provinces.json', __FILE__)
      end
    end
  end
end

require 'entities/province'
require 'lib/quadtree/point'
require 'lib/quadtree/rectangle'
require 'lib/quadtree/quarter'

module Spotippos
  class Kingdom
    class << self
      def find_province(point)
        quadtree.add_point(point).areas
      end

      def find_properties(rectangle)
        quadtree.find_area(rectangle).map(&:points).flatten
      end

      def quadtree
        return @quadtree if @quadtree

        @quadtree = Quadtree::Quarter.new(rectangle, provinces)
      end

      def provinces
        @provinces ||= JSON.parse(File.read(File.expand_path('../../../provinces.json', __FILE__))).map do |name, attributes|
          Spotippos::Province.new(
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

      private

      def rectangle
        @rectangle ||= Quadtree::Rectangle.new(upper_left, bottom_right)
      end

      def upper_left
        @upper_left ||= Quadtree::Point.new(
          provinces.map { |province| province.upper_left.x }.min,
          provinces.map { |province| province.upper_left.y }.max
        )
      end

      def bottom_right
        @bottom_right ||= Quadtree::Point.new(
          provinces.map { |province| province.bottom_right.x }.max,
          provinces.map { |province| province.bottom_right.y }.min
        )
      end
    end
  end
end

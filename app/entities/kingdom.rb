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

      private

      def quadtree
        @quadtree ||= Quadtree::Quarter.new(rectangle, provinces)
      end

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

      def provinces
        Province.all
      end
    end
  end
end

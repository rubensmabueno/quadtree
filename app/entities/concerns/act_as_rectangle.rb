require 'lib/quadtree/rectangle'

module Spotippos
  module ActAsRectangle
    def rectangle
      Quadtree::Rectangle.new(upper_left, bottom_right)
    end

    def method_missing(method_name, *arguments, &block)
      rectangle.send(method_name, *arguments, &block)
    end

    def respond_to?(method_name, include_private = false)
      rectangle.respond_to?(method_name, include_private) || super
    end
  end
end

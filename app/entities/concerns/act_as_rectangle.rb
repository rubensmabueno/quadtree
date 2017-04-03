require 'lib/quadtree/rectangle'

module Spotippos
  module ActAsRectangle
    def rectangle
      Quadtree::Rectangle.new(upper_left, bottom_right)
    end

    def method_missing(method_name, *arguments, &block)
      return rectangle.send(method_name, *arguments, &block) if rectangle.respond_to?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      rectangle.respond_to?(method_name, include_private) || super
    end
  end
end

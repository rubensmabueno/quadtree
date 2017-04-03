require 'lib/quadtree/point'

module Spotippos
  module ActAsPoint
    def point
      Quadtree::Point.new(x, y)
    end

    def method_missing(method_name, *arguments, &block)
      return point.send(method_name, *arguments, &block) if rectangle.respond_to?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      point.respond_to_missing?(method_name, include_private) || super
    end
  end
end

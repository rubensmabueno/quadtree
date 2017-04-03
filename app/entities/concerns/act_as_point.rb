require 'lib/quadtree/point'

module Spotippos
  module ActAsPoint
    def point
      Quadtree::Point.new(x, y)
    end

    def method_missing(method_name, *arguments, &block)
      point.send(method_name, *arguments, &block)
    end

    def respond_to?(method_name, include_private = false)
      point.respond_to?(method_name, include_private) || super
    end
  end
end

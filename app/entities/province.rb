require 'lib/quadtree/rectangle'

module Spotippos
  class Province < Quadtree::Rectangle
    attr_accessor :name, :upper_left, :bottom_right

    def initialize(name = nil, upper_left = nil, bottom_right = nil)
      super(upper_left, bottom_right)

      self.name = name
    end
  end
end

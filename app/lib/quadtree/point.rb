module Quadtree
  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      self.x = x
      self.y = y
    end

    def ==(other)
      return other.all? { |other_single| self.==(other_single) } if other.is_a?(Array)

      x == other.x && y == other.y
    end
  end
end

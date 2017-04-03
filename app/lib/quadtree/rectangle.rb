module Quadtree
  class Rectangle
    attr_accessor :upper_left, :bottom_right

    def initialize(upper_left, bottom_right)
      self.upper_left = upper_left
      self.bottom_right = bottom_right
    end

    # Check if this rectangle contains by the given point
    def contains?(point)
      upper_left.x <= point.x && bottom_right.x >= point.x &&
        upper_left.y >= point.y && bottom_right.y <= point.y
    end

    # Check if this rectangle contains the given rectangle
    def within?(rectangle)
      rectangle.upper_left.x <= upper_left.x && rectangle.bottom_right.x >= bottom_right.x &&
        rectangle.upper_left.y >= upper_left.y && rectangle.bottom_right.y <= bottom_right.y
    end

    # Check if this rectangle intersect the given rectangle
    def intersects?(rectangle)
      !(bottom_right.x <= rectangle.upper_left.x || upper_left.y <= rectangle.bottom_right.y ||
          upper_left.x >= rectangle.bottom_right.x || bottom_right.y >= rectangle.upper_left.y)
    end

    # A rectangle is related to another if it is contained, contains or is intersected by the other
    def related?(rectangle)
      within?(rectangle) || rectangle.within?(self) || intersects?(rectangle)
    end

    # Returns which given areas are contained by this rectangle
    def areas_within(areas)
      areas.select { |area| related?(area) }
    end

    # Returns which given points are contained by this rectangle
    def points_within(points)
      points.select { |point| contains?(point) }
    end

    def ==(other)
      upper_left == other.upper_left && bottom_right == other.bottom_right
    end
  end
end

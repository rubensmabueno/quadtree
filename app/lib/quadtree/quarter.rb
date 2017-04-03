require 'lib/quadtree/point'
require 'lib/quadtree/rectangle'

module Quadtree
  class Quarter
    LAMBDA = 1
    attr_accessor :rectangle, :areas, :points

    def initialize(rectangle, areas = [], points = [])
      self.rectangle = rectangle
      self.areas = areas
      self.points = points
    end

    # Recursive build until the leafs
    def build
      return if leaf?

      first_quarter.build
      second_quarter.build
      third_quarter.build
      fourth_quarter.build
    end

    def add_point(point)
      points << point

      return self if area_leaf?

      if first_quarter.rectangle.contains?(point)
        first_quarter.add_point(point)
      elsif second_quarter.rectangle.contains?(point)
        second_quarter.add_point(point)
      elsif third_quarter.rectangle.contains?(point)
        third_quarter.add_point(point)
      elsif fourth_quarter.rectangle.contains?(point)
        fourth_quarter.add_point(point)
      end
    end

    def find_area(area)
      return [self] if rectangle == area

      [first_quarter, second_quarter, third_quarter, fourth_quarter].inject([]) do |quarters, quarter|
        next quarters unless quarter.rectangle.related?(area) && quarter.points.length >= 1

        quarters += if quarter.rectangle.within?(area)
                      [quarter]
                    else
                      quarter.find_area(area)
        end

        quarters
      end
    end

    # Iterate through quarters which contains the given point until the given block is satisfacted and return the quadtree
    def find_point(point, &block)
      if first_quarter.points.include?(point)
        return first_quarter if first_quarter.area_leaf?

        first_quarter.find_point(point, &block)
      elsif second_quarter.points.include?(point)
        return second_quarter if second_quarter.area_leaf?

        second_quarter.find_point(point, &block)
      elsif third_quarter.points.include?(point)
        return third_quarter if third_quarter.area_leaf?

        third_quarter.find_point(point, &block)
      elsif fourth_quarter.points.include?(point)
        return fourth_quarter if fourth_quarter.area_leaf?

        fourth_quarter.find_point(point, &block)
      end
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def first_quarter
      @first_quarter ||= self.class.new(
        first_quarter_rectangle,
        first_quarter_rectangle.areas_within(areas),
        first_quarter_rectangle.points_within(points)
      )
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def second_quarter
      @second_quarter ||= self.class.new(
        second_quarter_rectangle,
        second_quarter_rectangle.areas_within(areas),
        second_quarter_rectangle.points_within(points)
      )
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def third_quarter
      @third_quarter ||= self.class.new(
        third_quarter_rectangle,
        third_quarter_rectangle.areas_within(areas),
        third_quarter_rectangle.points_within(points)
      )
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def fourth_quarter
      @fourth_quarter ||= self.class.new(
        fourth_quarter_rectangle,
        fourth_quarter_rectangle.areas_within(areas),
        fourth_quarter_rectangle.points_within(points)
      )
    end

    # Check if no point are contained and this rectangle is contained by all areas
    def area_leaf?
      points.empty? || areas.all? { |area| rectangle.within?(area) }
    end

    # Check if all points is contained by this rectangle
    def point_leaf?
      points.all? { |point| point == points.first } || points.length <= 1
    end

    def leaf?
      point_leaf? && area_leaf?
    end

    private

    # Return a rectangle representing the first quarter on clockwise direction
    def first_quarter_rectangle
      @first_quarter_rectangle ||= Rectangle.new(
        Point.new(upper_left.x, upper_left.y),
        Point.new(upper_left.x + quarter_length, upper_left.y - quarter_height)
      )
    end

    # Return a rectangle representing the second quarter on clockwise direction
    def second_quarter_rectangle
      @second_quarter_rectangle ||= Rectangle.new(
        Point.new(upper_left.x + quarter_length + LAMBDA, upper_left.y),
        Point.new(bottom_right.x, upper_left.y - quarter_height)
      )
    end

    # Return a rectangle representing the third quarter on clockwise direction
    def third_quarter_rectangle
      @third_quarter_rectangle ||= Rectangle.new(
        Point.new(upper_left.x, upper_left.y - quarter_height - LAMBDA),
        Point.new(upper_left.x + quarter_length, bottom_right.y)
      )
    end

    # Return a rectangle representing the fourth quarter on clockwise direction
    def fourth_quarter_rectangle
      @fourth_quarter_rectangle ||= Rectangle.new(
        Point.new(upper_left.x + quarter_length + LAMBDA, upper_left.y - quarter_height - LAMBDA),
        Point.new(bottom_right.x, bottom_right.y)
      )
    end

    # Return the length of half the rectangle
    def quarter_length
      @quarter_length ||= ((bottom_right.x - upper_left.x) / 2).ceil
    end

    # Return the height of half the rectangle
    def quarter_height
      @quarter_height ||= ((upper_left.y - bottom_right.y) / 2).ceil
    end

    def upper_left
      rectangle.upper_left
    end

    def bottom_right
      rectangle.bottom_right
    end
  end
end

require 'lib/quadtree/point'
require 'lib/quadtree/rectangle'

module Quadtree
  class Quarter < Rectangle
    LAMBDA = 1

    attr_accessor :upper_left, :bottom_right, :areas, :points

    def initialize(upper_left, bottom_right, areas = [], points = [])
      super(upper_left, bottom_right)

      self.areas = areas
      self.points = points
    end

    # Iterate through quarters which should contain the given point until it is a area_leaf
    def add_point(point)
      points << point unless points.include?(point)

      return self if area_leaf?

      if first_quarter.contains?(point)
        first_quarter.add_point(point)
      elsif second_quarter.contains?(point)
        second_quarter.add_point(point)
      elsif third_quarter.contains?(point)
        third_quarter.add_point(point)
      elsif fourth_quarter.contains?(point)
        fourth_quarter.add_point(point)
      end
    end

    def find_area(area)
      return [self] if self == area

      [first_quarter, second_quarter, third_quarter, fourth_quarter].inject([]) do |quarters, quarter|
        if quarter.related?(area) && quarter.points.length >= 1
          quarters += if quarter.within?(area)
                        [quarter]
                      else
                        quarter.find_area(area)
                      end
        end

        quarters
      end
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def first_quarter
      return @first_quarter if @first_quarter

      @first_quarter = self.class.new(
        Point.new(upper_left.x, upper_left.y),
        Point.new(upper_left.x + quarter_length, upper_left.y - quarter_height)
      )
      @first_quarter.areas = @first_quarter.areas_within(areas)
      @first_quarter.points = @first_quarter.points_within(points)
      @first_quarter
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def second_quarter
      return @second_quarter if @second_quarter

      @second_quarter = self.class.new(
        Point.new(upper_left.x + quarter_length + LAMBDA, upper_left.y),
        Point.new(bottom_right.x, upper_left.y - quarter_height)
      )
      @second_quarter.areas = @second_quarter.areas_within(areas)
      @second_quarter.points = @second_quarter.points_within(points)
      @second_quarter
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def third_quarter
      return @third_quarter if @third_quarter

      @third_quarter = self.class.new(
        Point.new(upper_left.x, upper_left.y - quarter_height - LAMBDA),
        Point.new(upper_left.x + quarter_length, bottom_right.y)
      )
      @third_quarter.areas = @third_quarter.areas_within(areas)
      @third_quarter.points = @third_quarter.points_within(points)
      @third_quarter
    end

    # Return a quadtree representing the first quarter on clockwise direction
    def fourth_quarter
      return @fourth_quarter if @fourth_quarter

      @fourth_quarter = self.class.new(
        Point.new(upper_left.x + quarter_length + LAMBDA, upper_left.y - quarter_height - LAMBDA),
        Point.new(bottom_right.x, bottom_right.y)
      )
      @fourth_quarter.areas = @fourth_quarter.areas_within(areas)
      @fourth_quarter.points = @fourth_quarter.points_within(points)
      @fourth_quarter
    end

    # Check if no point are contained and this rectangle is contained by all areas
    def area_leaf?
      points.empty? || areas.all? { |area| within?(area) }
    end

    # Check if all points is contained by this rectangle
    def point_leaf?
      points.all? { |point| point == points.first } || points.length <= 1
    end

    def leaf?
      point_leaf? && area_leaf?
    end

    private

    # Return the length of half the rectangle
    def quarter_length
      @quarter_length ||= ((bottom_right.x - upper_left.x) / 2).ceil
    end

    # Return the height of half the rectangle
    def quarter_height
      @quarter_height ||= ((upper_left.y - bottom_right.y) / 2).ceil
    end
  end
end

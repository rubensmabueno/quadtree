module Spotippos
  class Province
    include ActAsRectangle

    attr_accessor :name, :upper_left, :bottom_right

    def initialize(name = nil, upper_left = nil, bottom_right = nil)
      self.name = name
      self.upper_left = upper_left
      self.bottom_right = bottom_right
    end
  end
end

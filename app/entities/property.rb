module Spotippos
  class Property < ActiveRecord::Base
    def point
      Quadtree::Point.new(x, y)
    end

    def provinces
      Spotippos::Kingdom.find_province(self.point)
    end
  end
end

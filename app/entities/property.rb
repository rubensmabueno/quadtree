module Spotippos
  class Property < ActiveRecord::Base
    include ActAsPoint

    def provinces
      Spotippos::Kingdom.find_province(self)
    end
  end
end

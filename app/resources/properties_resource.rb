module Spotippos
  class PropertiesResource < Grape::API
    helpers do
      def snake_case_params
        Hash[params.map { |key, value| [key.underscore, value] }].symbolize_keys
      end
    end

    resource :properties do
      desc 'Create a property'
      params do
        requires :x, type: Integer, desc: 'Latitude location of the property'
        requires :y, type: Integer, desc: 'Longitude location of the property'
        requires :title, type: String, desc: 'Title given to the property'
        requires :price, type: Float, desc: 'Price of the property'
        requires :description, type: String, desc: 'A brief description of the property'
        requires :beds, type: Integer, desc: 'Number of beds of the property', values: (1..5)
        requires :baths, type: Integer, desc: 'Number of baths of the property', values: (1..4)
        requires :squareMeters, type: Integer, desc: 'Square meters of the property', values: (20..240)
      end
      post do
        property = Property.new(**snake_case_params)
        property.save

        present property, with: PropertyRepresenter
      end

      desc 'Find a property'
      get ':id' do
        property = Property[params[:id]]

        present property, with: PropertyRepresenter
      end

      desc 'Find a property within an area'
      params do
        requires :ax, type: Integer, desc: 'Latitude location of the upper_left of the area'
        requires :ay, type: Integer, desc: 'Longitude location of the upper_left of the area'
        requires :bx, type: Integer, desc: 'Latitude location of the bottom_right of the area'
        requires :by, type: Integer, desc: 'Longitude location of the bottom_right of the area'
      end
      get do
        properties = Kingdom.find_properties(
          Quadtree::Rectangle.new(
            Quadtree::Point.new(params[:ax], params[:ay]),
            Quadtree::Point.new(params[:bx], params[:by])
          )
        )

        present properties, with: PropertyCollectionRepresenter
      end
    end
  end
end

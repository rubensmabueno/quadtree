module Spotippos
  class PropertiesResource < Grape::API
    helpers do
      def snake_case_params
        Hash[params.map { |key, value| [key.underscore, value] }]
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
        requires :beds, type: Integer, desc: 'Number of beds of the property'
        requires :baths, type: Integer, desc: 'Number of baths of the property'
        requires :squareMeters, type: Integer, desc: 'Square meters of the property'
      end
      post do
        property = Property.create!(snake_case_params)

        present property, with: PropertyRepresenter
      end

      desc 'Find a property'
      get ':id' do
        property = Property.find(params[:id])

        present property, with: PropertyRepresenter
      end
    end
  end
end

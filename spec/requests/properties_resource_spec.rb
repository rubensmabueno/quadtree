require 'spec_helper'

describe Spotippos::PropertiesResource, type: :api do
  describe 'POST /properties' do
    context 'with required params' do
      let(:params) do
        {
          x: 1,
          y: 2,
          title: 'foo',
          price: 3,
          description: 'foo',
          beds: 4,
          baths: 4,
          squareMeters: 20
        }
      end

      it 'returns 201 status code, saves the property on the database and return a representer of it' do
        post '/properties', params

        property = Spotippos::Property.repository.values.first

        expect(property).to have_attributes(
          x: 1, y: 2, title: 'foo', price: 3, description: 'foo', beds: 4, baths: 4, square_meters: 20
        )

        expect(last_response.status).to eq 201
        expect(last_response.body).to eq(property.extend(Spotippos::PropertyRepresenter).to_json)
      end
    end
  end
end

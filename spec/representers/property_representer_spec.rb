# frozen_string_literal: true
require 'spec_helper'

describe Spotippos::PropertyRepresenter do
  describe '#to_json' do
    let(:property) do
      build_stubbed(
        :property,
        x: 10,
        y: 10,
        title: 'Property',
        price: 3000,
        description: 'Brief description',
        beds: 3,
        baths: 2,
        square_meters: 65
      )
    end
    let(:provinces) do
      [
        Spotippos::Province.new('foo', 'foo', 'bar'),
        Spotippos::Province.new('bar', 'foo', 'bar')
      ]
    end

    before do
      allow(property).to receive(:provinces) { provinces }
    end

    it 'transform model into a json object' do
      expect(JSON.parse(property.extend(described_class).to_json)).to include(
        'id' => property.id,
        'x' => 10,
        'y' => 10,
        'title' => 'Property',
        'price' => 3000.0,
        'description' => 'Brief description',
        'beds' => 3,
        'baths' => 2,
        'squareMeters' => 65,
        'provinces' => [ 'foo', 'bar' ]
      )
    end
  end
end

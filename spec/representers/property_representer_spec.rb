# frozen_string_literal: true
require 'spec_helper'

describe Spotippos::PropertyRepresenter do
  describe '#to_json' do
    let(:property) do
      Spotippos::Property.new(
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
        Spotippos::Province.new(name: 'foo', upper_left: 'foo', bottom_right: 'bar'),
        Spotippos::Province.new(name: 'bar', upper_left: 'foo', bottom_right: 'bar')
      ]
    end

    before do
      allow(property).to receive(:provinces) { provinces }
    end

    it 'transform model into a json object' do
      property.save

      expect(JSON.parse(property.extend(described_class).to_json)).to include(
        'id' => property.id,
        'x' => 10,
        'y' => 10,
        'title' => 'Property',
        'price' => 3000,
        'description' => 'Brief description',
        'beds' => 3,
        'baths' => 2,
        'squareMeters' => 65,
        'provinces' => %w(foo bar)
      )
    end
  end
end

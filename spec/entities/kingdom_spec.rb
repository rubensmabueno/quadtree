require 'spec_helper'

describe Spotippos::Kingdom do
  describe '.find_province' do
    let(:quadtree) { double(:quadtree, add_point: nil) }
    let(:areas) { [double(:area), double(:area)] }
    let(:quarter) { double(:quarter, areas: areas) }
    let(:point) { double(:point) }

    it 'calls on quadtree add_point with given point and returns respective areas' do
      expect(described_class).to receive(:quadtree) { quadtree }
      expect(quadtree).to receive(:add_point).with(point) { quarter }

      expect(described_class.find_province(point)).to eq(areas)
    end
  end

  describe '.find_properties' do
    let(:quadtree) { double(:quadtree, find_area: nil) }
    let(:area) { double(:area) }
    let(:quarters) { [double(:quarter, points: points)] }
    let(:points) { [double(:points), double(:points)] }

    it 'calls on quadtree find_area with given area and returns respective properties' do
      expect(described_class).to receive(:quadtree) { quadtree }
      expect(quadtree).to receive(:find_area).with(area) { quarters }

      expect(described_class.find_properties(area)).to eq(points)
    end
  end
end

require 'spec_helper'

describe Spotippos::Property do
  subject { build(:property) }

  describe '#point' do
    it 'returns an instance of point with x and y' do
      point = subject.point

      expect(point).to be_an_instance_of(Quadtree::Point)
      expect(point.x).to eq(subject.x)
      expect(point.y).to eq(subject.y)
    end
  end

  describe '#provinces' do
    let(:provinces) { double(:provinces) }
    let(:point) { double(:point) }

    it 'returns provinces for the property point' do
      expect(subject).to receive(:point) { point }
      expect(Spotippos::Kingdom).to receive(:find_province).with(point) { provinces }

      expect(subject.provinces).to eq(provinces)
    end
  end
end

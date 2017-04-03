require 'spec_helper'

describe Spotippos::Property do
  subject { described_class.new(**attributes) }
  let(:attributes) do
    {
      x: 1,
      y: 2,
      title: 'foo',
      price: 4,
      description: 'foo',
      beds: 5,
      baths: 6,
      square_meters: 7
    }
  end

  describe '#provinces' do
    let(:provinces) { double(:provinces) }

    it 'returns provinces for the property point' do
      expect(Spotippos::Kingdom).to receive(:find_province).with(subject) { provinces }

      expect(subject.provinces).to eq(provinces)
    end
  end
end

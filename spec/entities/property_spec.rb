require 'spec_helper'

describe Spotippos::Property do
  subject { build(:property) }

  describe '#provinces' do
    let(:provinces) { double(:provinces) }

    it 'returns provinces for the property point' do
      expect(Spotippos::Kingdom).to receive(:find_province).with(subject) { provinces }

      expect(subject.provinces).to eq(provinces)
    end
  end
end

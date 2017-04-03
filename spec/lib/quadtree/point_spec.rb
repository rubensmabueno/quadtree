require 'spec_helper'

describe Quadtree::Point do
  describe '#==' do
    context 'when both have the same content' do
      subject { described_class.new(1, 1) }
      let(:other) { described_class.new(1, 1) }

      it { is_expected.to eq(other) }
    end

    context 'when other have the different content' do
      subject { described_class.new(1, 1) }
      let(:other) { described_class.new(1, 2) }

      it { is_expected.not_to eq(other) }
    end
  end
end

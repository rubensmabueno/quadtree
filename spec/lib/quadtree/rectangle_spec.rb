require 'spec_helper'

describe Quadtree::Rectangle do
  describe '#==' do
    context 'when both have the same content' do
      subject { described_class.new(Quadtree::Point.new(1, 1), Quadtree::Point.new(1, 1)) }
      let(:other) { described_class.new(Quadtree::Point.new(1, 1), Quadtree::Point.new(1, 1)) }

      it { is_expected.to eq(other) }
    end

    context 'when other have the different content' do
      subject { described_class.new(Quadtree::Point.new(1, 1), Quadtree::Point.new(1, 1)) }
      let(:other) { described_class.new(Quadtree::Point.new(1, 1), Quadtree::Point.new(2, 2)) }

      it { is_expected.not_to eq(other) }
    end
  end

  describe '#contains?' do
    context 'when point is inside' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:point) { Quadtree::Point.new(5, 5) }

      it 'returns true' do
        expect(subject.contains?(point)).to be_truthy
      end
    end

    context 'when point is intersects the border' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:point) { Quadtree::Point.new(10, 10) }

      it 'returns true' do
        expect(subject.contains?(point)).to be_truthy
      end
    end

    context 'when point is not inside' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:point) { Quadtree::Point.new(11, 5) }

      it 'returns false' do
        expect(subject.contains?(point)).to be_falsey
      end
    end
  end

  describe '#within?' do
    context 'when rectangle is inside' do
      subject { described_class.new(Quadtree::Point.new(2, 9), Quadtree::Point.new(9, 2)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

      it 'returns true' do
        expect(subject.within?(rectangle)).to be_truthy
      end
    end

    context 'when rectangle is intersects the border' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

      it 'returns true' do
        expect(subject.within?(rectangle)).to be_truthy
      end
    end

    context 'when rectangle is not inside' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(11, 20), Quadtree::Point.new(20, 11)) }

      it 'returns false' do
        expect(subject.within?(rectangle)).to be_falsey
      end
    end
  end

  describe '#intersects?' do
    context 'when rectangle intersects' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(5, 15), Quadtree::Point.new(15, 5)) }

      it 'returns true' do
        expect(subject.intersects?(rectangle)).to be_truthy
      end
    end

    context 'when rectangle intersects the border' do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(9, 11), Quadtree::Point.new(11, 9)) }

      it 'returns true' do
        expect(subject.intersects?(rectangle)).to be_truthy
      end
    end

    context "when rectangle don't intersect" do
      subject { described_class.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
      let(:rectangle) { described_class.new(Quadtree::Point.new(20, 30), Quadtree::Point.new(30, 20)) }

      it 'returns false' do
        expect(subject.intersects?(rectangle)).to be_falsey
      end
    end
  end

  describe '#related?' do
    context 'when within' do
      subject { described_class.new('foo', 'bar') }
      let(:rectangle) { described_class.new('foo', 'bar') }

      before do
        allow(subject).to receive(:within?).with(rectangle) { true }
        allow(rectangle).to receive(:within?).with(subject) { false }
        allow(subject).to receive(:intersects?).with(rectangle) { false }
      end

      it 'returns true' do
        expect(subject.related?(rectangle)).to be_truthy
      end
    end

    context 'when intersects' do
      subject { described_class.new('foo', 'bar') }
      let(:rectangle) { described_class.new('foo', 'bar') }

      before do
        allow(subject).to receive(:within?).with(rectangle) { false }
        allow(rectangle).to receive(:within?).with(subject) { true }
        allow(subject).to receive(:intersects?).with(rectangle) { false }
      end

      it 'returns true' do
        expect(subject.related?(rectangle)).to be_truthy
      end
    end

    context 'when the other is within' do
      subject { described_class.new('foo', 'bar') }
      let(:rectangle) { described_class.new('foo', 'bar') }

      before do
        allow(subject).to receive(:within?).with(rectangle) { false }
        allow(rectangle).to receive(:within?).with(subject) { false }
        allow(subject).to receive(:intersects?).with(rectangle) { true }
      end

      it 'returns true' do
        expect(subject.related?(rectangle)).to be_truthy
      end
    end

    context 'when is not within and is not intersected' do
      subject { described_class.new('foo', 'bar') }
      let(:rectangle) { described_class.new('foo', 'bar') }

      before do
        allow(subject).to receive(:within?).with(rectangle) { false }
        allow(rectangle).to receive(:within?).with(subject) { false }
        allow(subject).to receive(:intersects?).with(rectangle) { false }
      end

      it 'returns false' do
        expect(subject.related?(rectangle)).to be_falsey
      end
    end
  end

  describe '#areas_within' do
    subject { described_class.new('foo', 'bar') }
    let(:rectangle_1) { described_class.new('foo', 'bar') }
    let(:rectangle_2) { described_class.new('foo', 'bar') }

    it 'returns the rectangle related' do
      expect(subject).to receive(:related?).with(rectangle_1) { false }
      expect(subject).to receive(:related?).with(rectangle_2) { true }

      expect(subject.areas_within([rectangle_1, rectangle_2])).to eq([rectangle_2])
    end
  end

  describe '#points_within' do
    subject { described_class.new('foo', 'bar') }
    let(:point_1) { Quadtree::Point.new('foo', 'bar') }
    let(:point_2) { Quadtree::Point.new('foo', 'bar') }

    it 'returns the contained point' do
      expect(subject).to receive(:contains?).with(point_1) { false }
      expect(subject).to receive(:contains?).with(point_2) { true }

      expect(subject.points_within([point_1, point_2])).to eq([point_2])
    end
  end
end

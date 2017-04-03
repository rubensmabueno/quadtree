require 'lib/quadtree/quarter'

describe Quadtree::Quarter do
  describe '#find_area' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

    context 'when there are areas within the quarter' do
      let(:area) { Quadtree::Rectangle.new(Quadtree::Point.new(2, 9), Quadtree::Point.new(9, 2)) }
      let(:areas) do
        [
          Quadtree::Rectangle.new(Quadtree::Point.new(2, 4), Quadtree::Point.new(4, 2)),
          Quadtree::Rectangle.new(Quadtree::Point.new(6, 9), Quadtree::Point.new(9, 6))
        ]
      end

      context 'and there are points inside them' do
        let(:points) { [Quadtree::Point.new(3, 3), Quadtree::Point.new(6, 6)] }

        it 'returns quarters with both points inside' do
          self_quarters = subject.find_area(area)
          self_points = self_quarters.map(&:points)

          expect(self_points).to contain_exactly(*points)
          expect(self_quarters).to all(be_a(Quadtree::Quarter))
        end
      end

      context 'and there are no points inside them' do
        let(:points) { [] }

        it 'returns no quarters' do
          self_quarters = subject.find_area(area)

          expect(self_quarters).to be_empty
        end
      end
    end
  end

  describe '#find_point' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

    context 'when there are points inside the area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(3, 6), Quadtree::Point.new(6, 3))] }
      let(:points) { [Quadtree::Point.new(5, 5)] }

      it 'returns an quarter which is contained by the given area' do
        quarter = subject.find_point(points.first)

        expect(quarter.rectangle.within?(areas.first)).to be_truthy
        expect(quarter.rectangle.contains?(points.first)).to be_truthy
      end
    end

    context 'when there are no points inside the area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(3, 6), Quadtree::Point.new(6, 3))] }
      let(:points) { [Quadtree::Point.new(11, 11)] }

      it 'returns nil' do
        expect(subject.find_point(points.first)).to be_nil
      end
    end

    context 'when there are points inside more than one area' do
      let(:areas) do
        [
          Quadtree::Rectangle.new(Quadtree::Point.new(3, 6), Quadtree::Point.new(6, 3)),
          Quadtree::Rectangle.new(Quadtree::Point.new(4, 7), Quadtree::Point.new(7, 4))
        ]
      end
      let(:points) { [Quadtree::Point.new(5, 5)] }

      it 'returns an quarter which is contained by both given area' do
        quarter = subject.find_point(points.first)

        expect(quarter.rectangle.within?(areas.first)).to be_truthy
        expect(quarter.rectangle.within?(areas.second)).to be_truthy
        expect(quarter.rectangle.contains?(points.first)).to be_truthy
      end
    end
  end

  describe '#area_leaf?' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

    context 'with two areas around' do
      let(:areas) do
        [
          Quadtree::Rectangle.new(Quadtree::Point.new(0, 11), Quadtree::Point.new(11, 0)),
          Quadtree::Rectangle.new(Quadtree::Point.new(0, 12), Quadtree::Point.new(12, 0))
        ]
      end
      let(:points) { [Quadtree::Point.new(5, 5)] }

      it 'returns true' do
        expect(subject.area_leaf?).to be_truthy
      end
    end

    context 'with no area around' do
      let(:areas) do
        [
          Quadtree::Rectangle.new(Quadtree::Point.new(11, 12), Quadtree::Point.new(12, 11)),
          Quadtree::Rectangle.new(Quadtree::Point.new(13, 14), Quadtree::Point.new(14, 13))
        ]
      end
      let(:points) { [Quadtree::Point.new(5, 5)] }

      it 'returns false' do
        expect(subject.area_leaf?).to be_falsey
      end
    end

    context 'with no points inside' do
      let(:areas) do
        [
          Quadtree::Rectangle.new(Quadtree::Point.new(0, 11), Quadtree::Point.new(11, 0)),
          Quadtree::Rectangle.new(Quadtree::Point.new(0, 12), Quadtree::Point.new(12, 0))
        ]
      end
      let(:points) { [] }

      it 'returns true' do
        expect(subject.area_leaf?).to be_truthy
      end
    end
  end

  describe '#point_leaf?' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }

    context 'with all points are equal' do
      let(:areas) { [] }
      let(:points) { [Quadtree::Point.new(5, 5), Quadtree::Point.new(5, 5)] }

      it 'returns true' do
        expect(subject.point_leaf?).to be_truthy
      end
    end

    context 'when no points is inside' do
      let(:areas) { [] }
      let(:points) { [] }

      it 'returns true' do
        expect(subject.point_leaf?).to be_truthy
      end
    end
  end

  describe '#first_quarter' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
    let(:areas) { [] }
    let(:points) { [] }

    it 'returns the first quarter of the rectangle on clockwise direction' do
      expect(subject.first_quarter.rectangle).to eq(
        Quadtree::Rectangle.new(
          Quadtree::Point.new(1, 10),
          Quadtree::Point.new(5, 6)
        )
      )
    end

    context 'when first quarter have area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(3, 7), Quadtree::Point.new(4, 9))] }

      it 'initialize the first_quarter with the area' do
        expect(subject.first_quarter.areas).to eq(areas)
      end
    end

    context 'when first quarter does not contain area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(6, 2), Quadtree::Point.new(7, 1))] }

      it 'initialize the first_quarter with the area' do
        expect(subject.first_quarter.areas).to be_empty
      end
    end

    context 'when first quarter have points' do
      let(:points) { [Quadtree::Point.new(2, 7)] }

      it 'initialize the first_quarter with the point' do
        expect(subject.first_quarter.points).to eq(points)
      end
    end

    context 'when first quarter do not have points' do
      let(:points) { [Quadtree::Point.new(6, 2)] }

      it 'initialize the first_quarter without the point' do
        expect(subject.first_quarter.points).to be_empty
      end
    end
  end

  describe '#second_quarter' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
    let(:areas) { [] }
    let(:points) { [] }

    it 'returns the second quarter of the rectangle on clockwise direction' do
      expect(subject.second_quarter.rectangle).to eq(
        Quadtree::Rectangle.new(
          Quadtree::Point.new(6, 10),
          Quadtree::Point.new(10, 6)
        )
      )
    end

    context 'when second quarter have area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(7, 7), Quadtree::Point.new(8, 9))] }

      it 'initialize the second_quarter with the area' do
        expect(subject.second_quarter.areas).to eq(areas)
      end
    end

    context 'when second quarter does not contain area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(6, 2), Quadtree::Point.new(7, 1))] }

      it 'initialize the second_quarter without the area' do
        expect(subject.second_quarter.areas).to be_empty
      end
    end

    context 'when second quarter have points' do
      let(:points) { [Quadtree::Point.new(6, 7)] }

      it 'initialize the second_quarter with the point' do
        expect(subject.second_quarter.points).to eq(points)
      end
    end

    context 'when second quarter does not have points' do
      let(:points) { [Quadtree::Point.new(6, 2)] }

      it 'initialize the second_quarter without the point' do
        expect(subject.second_quarter.points).to be_empty
      end
    end
  end

  describe '#third_quarter' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
    let(:areas) { [] }
    let(:points) { [] }

    it 'returns the second quarter of the rectangle on clockwise direction' do
      expect(subject.third_quarter.rectangle).to eq(
        Quadtree::Rectangle.new(
          Quadtree::Point.new(1, 5),
          Quadtree::Point.new(5, 1)
        )
      )
    end

    context 'when third quarter have area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(3, 4), Quadtree::Point.new(4, 3))] }

      it 'initialize the third_quarter with the area' do
        expect(subject.third_quarter.areas).to eq(areas)
      end
    end

    context 'when third quarter does not contain area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(6, 2), Quadtree::Point.new(7, 1))] }

      it 'initialize the third_quarter without the area' do
        expect(subject.third_quarter.areas).to be_empty
      end
    end

    context 'when third quarter have points' do
      let(:points) { [Quadtree::Point.new(4, 4)] }

      it 'initialize the third_quarter with the point' do
        expect(subject.third_quarter.points).to eq(points)
      end
    end

    context 'when third quarter does not have points' do
      let(:points) { [Quadtree::Point.new(6, 2)] }

      it 'initialize the third_quarter without the point' do
        expect(subject.third_quarter.points).to be_empty
      end
    end
  end

  describe '#fourth_quarter' do
    subject { described_class.new(rectangle, areas, points) }

    let(:rectangle) { Quadtree::Rectangle.new(Quadtree::Point.new(1, 10), Quadtree::Point.new(10, 1)) }
    let(:areas) { [] }
    let(:points) { [] }

    it 'returns the fourth quarter of the rectangle on clockwise direction' do
      expect(subject.fourth_quarter.rectangle).to eq(
        Quadtree::Rectangle.new(
          Quadtree::Point.new(6, 5),
          Quadtree::Point.new(10, 1)
        )
      )
    end

    context 'when fourth quarter have area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(7, 3), Quadtree::Point.new(8, 2))] }

      it 'initialize the fourth_quarter with the area' do
        expect(subject.fourth_quarter.areas).to eq(areas)
      end
    end

    context 'when fourth quarter does not contain area' do
      let(:areas) { [Quadtree::Rectangle.new(Quadtree::Point.new(3, 7), Quadtree::Point.new(4, 6))] }

      it 'initialize the fourth_quarter without the area' do
        expect(subject.fourth_quarter.areas).to be_empty
      end
    end

    context 'when fourth quarter have points' do
      let(:points) { [Quadtree::Point.new(7, 4)] }

      it 'initialize the fourth_quarter with the point' do
        expect(subject.fourth_quarter.points).to eq(points)
      end
    end

    context 'when fourth quarter does not have points' do
      let(:points) { [Quadtree::Point.new(4, 7)] }

      it 'initialize the fourth_quarter without the point' do
        expect(subject.fourth_quarter.points).to be_empty
      end
    end
  end
end

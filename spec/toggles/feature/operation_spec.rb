# frozen_string_literal: true
 
RSpec.describe 'operations' do
  context 'and' do
    subject { Feature.operations[:and] }

    specify do
    [[60, true], [40, false], [80, false]].each do |(id, expected)|
        expect(
          subject.call(double(id: id), :id, {"gt" => 50, "lt" => 70})
        ).to eq expected
      end
    end
  end

  context 'gt' do
    subject { Feature.operations[:gt] }

    specify do
      expect(subject.call(double(id: 50), :id, 40)).to eq true
      expect(subject.call(double(id: 50), :id, 60)).to eq false
    end
  end

  context 'in' do
    subject { Feature.operations[:in] }

    specify do
      expect(subject.call(double(id: 50), :id, {"range" => [40, 60]})).to eq true
      expect(subject.call(double(id: 50), :id, [1])).to eq false
      expect(subject.call(double(id: nil), :id, [1])).to eq false
    end
  end

  context 'lt' do
    subject { Feature.operations[:lt] }

    specify do
      expect(subject.call(double(id: 50), :id, 60)).to eq true
      expect(subject.call(double(id: 50), :id, 40)).to eq false
    end
  end

  context 'not' do
    subject { Feature.operations[:not] }

    specify do
      expect(subject.call(double(id: 50), :id, {"in" => (10..20)})).to eq true
      expect(subject.call(double(id: 50), :id, 50)).to eq false
    end
  end

  context 'or' do
    subject { Feature.operations[:or] }

    specify do
      expect(subject.call(double(id: 16), :id, {"in" => (10..20), "not" => 15})).to eq true
      expect(subject.call(double(id: 15), :id, {"in" => (10..20), "not" => 15})).to eq true
    end
  end

  context 'range' do
    subject { Feature.operations[:range] }

    specify do
      expect(subject.call([10, 20])).to eq((10..20))
    end
  end
end

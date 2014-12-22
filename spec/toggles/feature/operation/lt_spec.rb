describe Feature::Operation::LessThan do
  specify do
    expect(described_class.call(double(id: 50), :id, 60)).to eq true
    expect(described_class.call(double(id: 50), :id, 40)).to eq false
  end
end

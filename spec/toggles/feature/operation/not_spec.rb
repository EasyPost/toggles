describe Feature::Operation::Not do
  specify do
    expect(described_class.call(double(id: 50), :id, {"in" => (10..20)})).to eq true
    expect(described_class.call(double(id: 50), :id, 50)).to eq false
  end
end

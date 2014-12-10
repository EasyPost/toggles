describe Feature::Permissions::Operation::Attribute do
  specify do
    expect(described_class.call(double(id: 50), :id, 50)).to eq true
    expect(described_class.call(double(id: 50), :id, 51)).to eq false

    expect(described_class.call(double(id: 50), :id, {"in" => (0..50), "not" => 49})).to eq true
    expect(described_class.call(double(id: 49), :id, {"in" => (0..50), "not" => 49})).to eq false
  end
end

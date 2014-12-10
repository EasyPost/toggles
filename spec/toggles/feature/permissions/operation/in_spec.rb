describe Feature::Permissions::Operation::In do
  specify do
    expect(described_class.call(double(id: 50), :id, {"range" => [40, 60]})).to eq true
    expect(described_class.call(double(id: 50), :id, [1])).to eq false
  end
end

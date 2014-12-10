describe Feature::Permissions::Operation::Or do
  specify do
    expect(described_class.call(double(id: 16), :id, {"in" => (10..20), "not" => 15})).to eq true
    expect(described_class.call(double(id: 15), :id, {"in" => (10..20), "not" => 15})).to eq true
  end
end

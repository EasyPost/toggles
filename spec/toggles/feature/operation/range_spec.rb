describe Feature::Operation::Range do
  specify do
    expect(described_class.call([10, 20])).to eq (10..20)
  end
end

describe "Feature::ComplexAnd" do
  specify do
    expect(Feature::ComplexAnd.enabled_for?(data: double(id: 1))).to eq true
    expect(Feature::ComplexAnd.enabled_for?(data: double(id: 2, timestamp: 0))).to eq true
    expect(Feature::ComplexAnd.enabled_for?(data: double(id: 2, timestamp: 20))).to eq false
  end
end

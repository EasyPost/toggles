describe "Feature::Collection" do
  specify do
    expect(Feature::Collection.enabled_for?(user: double(id: 1))).to eq true
    expect(Feature::Collection.enabled_for?(user: double(id: 5))).to eq true
    expect(Feature::Collection.enabled_for?(user: double(id: 10))).to eq true
    expect(Feature::Collection.enabled_for?(user: double(id: 49))).to eq false
    expect(Feature::Collection.enabled_for?(user: double(id: 51))).to eq true
    expect(Feature::Collection.enabled_for?(user: nil)).to eq false
  end
end

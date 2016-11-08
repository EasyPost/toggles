describe "Feature::Type" do
  specify do
    expect(Feature::Type.enabled_for?(user_id: 1)).to eq true
    expect(Feature::Type.enabled_for?(user_id: 25)).to eq false
    expect(Feature::Type.enabled_for?(user_id: nil)).to eq false
  end
end

describe "Feature::Type" do
  specify do
    aggregate_failures do
      expect(Feature::Type.enabled_for?(user_id: 1)).to eq true
      expect(Feature::Type.enabled_for?(user_id: 25)).to eq false
      expect(Feature::Type.enabled_for?(user_id: nil)).to eq false
      expect(Feature.enabled?(:type, user_id: 1)).to eq(true)
      expect(Feature.disabled?(:type, user_id: 1)).to eq(false)
      expect(Feature.enabled?(:type, user_id: 25)).to eq(false)
    end
  end
end

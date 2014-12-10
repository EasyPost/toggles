describe Feature::Base do
  let(:user)   { double(id: 1, logged_in?: true) }
  let(:widget) { double(id: 2) }

  subject { Feature::Test.new(user: user, widget: widget) }

  its(:enabled?)              { is_expected.to eq true }
  its(:subjects)              { is_expected.to eq user: user, widget: widget }
  its("permissions.subjects") { is_expected.to eq [:user, :widget] }

  describe "#enabled_for?" do
    specify do
      expect(Feature::Test.enabled_for?(user: double(id: 1, logged_in?: true),
                                        widget: double(id: 2))).to eq true
      expect(Feature::Test.enabled_for?(user: double(id: 1, logged_in?: false),
                                        widget: double(id: 2))).to eq false
    end

    specify "invalid permissions" do
      expect { Feature::Test.enabled_for?(widget: double) }.
        to raise_error Feature::Subject::Invalid, "Invalid subjects for permissions: [:user]"
    end

    specify "collection" do
      expect(Feature::Collection.enabled_for?(user: double(id: 1))).to eq true
      expect(Feature::Collection.enabled_for?(user: double(id: 5))).to eq true
      expect(Feature::Collection.enabled_for?(user: double(id: 10))).to eq true
      expect(Feature::Collection.enabled_for?(user: double(id: 49))).to eq false
      expect(Feature::Collection.enabled_for?(user: double(id: 51))).to eq true
    end
  end
end

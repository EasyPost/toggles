describe Feature::Permissions do
  let(:path) { "features/test.yml" }

  subject { Feature::Permissions.new(path) }

  its(:path)     { is_expected.to eq path }
  its(:rules)    { is_expected.to eq({"user"=>{"id"=>1, "logged_in?"=>true},
                                      "widget"=>{"id"=>2}}) }
  its(:subjects) { [:user, :widget] }

  describe "#valid_for?" do
    specify do
      expect(subject.valid_for?(user: double(id: 1, logged_in?: true),
                                widget: double(id: 2))).to eq true
      expect(subject.valid_for?(user: double(id: 2, logged_in?: true),
                                widget: double(id: 2))).to eq false
    end

    specify "invalid subjects" do
      expect { subject.valid_for?(user: double) }.
        to raise_error Feature::Subject::Invalid,
          "Invalid or missing subjects for permissions: [:widget]"
    end
  end
end

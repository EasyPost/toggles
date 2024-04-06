describe Feature::Permissions do
  let(:path) { "features/multiple_subjects.yml" }

  subject { Feature::Permissions.from_yaml(path) }

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

    specify 'subjects can be specified in any order' do
      expect(subject.valid_for?(widget: double(id: 2),
                                user: double(id: 2, logged_in?: true))).to eq false
    end

    specify "invalid subjects" do
      expect { subject.valid_for?(user: double) }.
        to raise_error Feature::Subject::Invalid,
          "Invalid or missing subjects for permissions: [:widget]"
    end
  end
end

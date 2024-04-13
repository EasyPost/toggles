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
                                user: double(id: 1, logged_in?: true))).to eq true
      expect(subject.valid_for?(widget: double(id: 2),
                                user: double(id: 2, logged_in?: true))).to eq false
    end

    specify 'partial subjects are acceptable', :aggregate_failures do
      # partial subjects that match
      expect(subject.valid_for?(user: double(id: 1, logged_in?: true))).to eq true
      expect(subject.valid_for?(widget: double(id: 2))).to eq true

      # partial subjects that do not match
      expect(subject.valid_for?(widget: double(id: 3))).to eq false
      expect(subject.valid_for?(user: double(id: 2, logged_in?: true))).to eq false
    end

    specify "unspecified subjects are not acceptable" do
      expect { subject.valid_for?(foo: double) }.
        to raise_error Feature::Subject::NotApplicable,
          "Subjects not applicable for permissions: [:foo]"

      # partial specification with an invalid subject is still an error
      expect { subject.valid_for?(user: double(id: 1), foo: double) }.
        to raise_error Feature::Subject::NotApplicable,
          "Subjects not applicable for permissions: [:foo]"
    end

    specify "empty subjects are invalid" do
      expect { subject.valid_for?({}) }.to raise_error Feature::Subject::Empty
    end
  end
end

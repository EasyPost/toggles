describe Feature::Subject do
  describe Feature::Subject::Invalid do
    subject { Feature::Subject::Invalid.new([:user]) }

    its(:message) { is_expected.to eq "Invalid subjects for permissions: [:user]" }
  end

  describe "#difference" do
    specify do
      expect(Feature::Subject.difference([:foo, :bar], [:bar])).to eq [:foo]
      expect(Feature::Subject.difference([:bar], [:foo, :bar])).to eq [:foo]
      expect(Feature::Subject.difference([:bar], [:foo])).to eq [:bar, :foo]
    end
  end
end

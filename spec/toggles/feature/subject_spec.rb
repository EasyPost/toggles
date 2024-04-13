describe Feature::Subject do
  describe Feature::Subject::Invalid do
    subject { Feature::Subject::Invalid.new([:user]) }

    its(:message) { is_expected.to eq "Invalid or missing subjects for permissions: [:user]" }
  end
end

class User
  attr_reader :id

  def initialize(id, bool)
    @id   = id
    @bool = bool
  end

  def logged_in?
    @bool
  end
end

class Widget
  def id; 2; end
end

describe Feature::Base do
  describe "#enabled_for?" do
    specify do
      expect(Feature::Test.enabled_for?(User.new(1, true), Widget.new)).to eq true
      expect(Feature::Test.enabled_for?(User.new(1, false), Widget.new)).to eq false
    end

    specify "invalid permissions" do
      expect { Feature::Test.enabled_for?(Widget.new) }.
        to raise_error Feature::Subject::Invalid, "Invalid subjects for permissions: [:user]"
    end
  end
end

describe Feature::Subject do
  describe Feature::Subject::Invalid do
    subject { Feature::Subject::Invalid.new([:user]) }

    its(:message) { is_expected.to eq "Invalid subjects for permissions: [:user]" }
  end
end

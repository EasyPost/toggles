require 'spec_helper'

describe Toggles::Configuration do
  describe "#features_dir" do
    subject { Toggles::configuration.features_dir }

    it { is_expected.to eq "features" }
  end
end

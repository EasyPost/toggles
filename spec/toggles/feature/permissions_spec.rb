describe Feature::Permissions do
  let(:path) { "features/test.yml" }

  subject { Feature::Permissions.new(path) }

  its(:path) { is_expected.to eq path }
end

describe Feature::Base do
  let(:user)   { double(id: 1, logged_in?: true) }
  let(:widget) { double(id: 2) }

  context 'multiple subjects' do
    subject { Feature::MultipleSubjects.new(user: user, widget: widget) }

    its(:enabled?)              do is_expected.to eq true end
    its(:subjects)              do is_expected.to eq user: user, widget: widget end
    its('permissions.subjects') { is_expected.to eq %i[user widget] }
  end

  context 'abbreviation with numbers' do
    subject { Feature::AbbreviationsCN22.new(user: user) }

    its(:enabled?)              do is_expected.to eq true end
    its(:subjects)              do is_expected.to eq user: user end
    its('permissions.subjects') { is_expected.to eq [:user] }
  end

  context 'irregular capitalization' do
    subject { Feature::S3File.new(user: user) }

    its(:enabled?)              do is_expected.to eq true end
    its(:subjects)              do is_expected.to eq user: user end
    its('permissions.subjects') { is_expected.to eq [:user] }
  end

  context 'irregular capitalization' do
    subject { Feature::FileS3.new(user: user) }

    its(:enabled?)              do is_expected.to eq true end
    its(:subjects)              do is_expected.to eq user: user end
    its('permissions.subjects') { is_expected.to eq [:user] }
  end
end

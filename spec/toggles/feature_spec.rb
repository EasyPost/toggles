describe 'features' do
  let(:user)   { double(id: 1, logged_in?: true) }
  let(:widget) { double(id: 2) }

  context 'multiple subjects' do
    specify { expect(Feature).to be_enabled(:multiple_subjects, user: user, widget: widget) }
    specify { expect(Feature::MultipleSubjects).to be_enabled_for(user: user, widget: widget) }
    specify { expect(Feature).not_to be_disabled(:multiple_subjects, user: user, widget: widget) }
    specify { expect(Feature::MultipleSubjects).not_to be_disabled_for(user: user, widget: widget) }
  end

  context 'abbreviation with numbers' do
    subject { Feature::AbbreviationsCN22.new(user: user) }

    specify { expect(Feature).to be_enabled(:abbreviations_cn22, user: user) }
    specify { expect(Feature::AbbreviationsCN22).to be_enabled_for(user: user) }
    specify { expect(Feature).not_to be_disabled(:abbreviations_cn22, user: user) }
    specify { expect(Feature::AbbreviationsCN22).not_to be_disabled_for(user: user) }
  end

  context 'irregular capitalization' do
    specify { expect(Feature).to be_enabled(:s3_file, user: user) }
    specify { expect(Feature::S3File).to be_enabled_for(user: user) }
    specify { expect(Feature).not_to be_disabled(:s3_file, user: user) }
    specify { expect(Feature).to be_disabled(:s3_file, user: widget) }
    specify { expect(Feature::S3File).not_to be_disabled_for(user: user) }
    specify { expect(Feature::S3File).to be_disabled_for(user: widget) }
  end

  context 'irregular capitalization' do
    specify { expect(Feature).to be_enabled(:file_s3, user: user) }
    specify { expect(Feature::FileS3).to be_enabled_for(user: user) }
    specify { expect(Feature).not_to be_disabled(:file_s3, user: user) }
    specify { expect(Feature::FileS3).not_to be_disabled_for(user: user) }
    specify { expect(Feature).to be_disabled(:file_s3, user: widget) }
  end
end

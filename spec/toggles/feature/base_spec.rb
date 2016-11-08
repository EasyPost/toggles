require 'spec_helper'

describe Feature::Base do
  let(:user)   { double(id: 1, logged_in?: true) }
  let(:widget) { double(id: 2) }

  subject { Feature::MultipleSubjects.new(user: user, widget: widget) }

  its(:enabled?)              { is_expected.to eq true }
  its(:subjects)              { is_expected.to eq user: user, widget: widget }
  its("permissions.subjects") { is_expected.to eq [:user, :widget] }
end

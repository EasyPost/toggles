describe "Feature::MultipleSubjects" do
  specify do
    expect(Feature::MultipleSubjects.enabled_for?(
      user: double(id: 1, logged_in?: true), widget: double(id: 2))).to eq true

    expect(Feature::MultipleSubjects.enabled_for?(
      user: double(id: 1, logged_in?: false), widget: double(id: 2))).to eq false
    expect(Feature::MultipleSubjects.enabled_for?(
      user: double(id: 1, logged_in?: true), widget: double(id: 3))).to eq false

    expect(Feature::MultipleSubjects.enabled_for?(
      user: double(id: 1, logged_in?: true))).to eq true
    expect(Feature::MultipleSubjects.enabled_for?(
      widget: double(id: 3)
    )).to eq false
  end
end

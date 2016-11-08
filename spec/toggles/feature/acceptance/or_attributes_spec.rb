describe "Feature::OrAttributes" do
  specify do
    expect(Feature::OrAttributes.enabled_for?(
      user: double(foo: 20, bar: 10))).to eq true
    expect(Feature::OrAttributes.enabled_for?(
      user: double(foo: 10, bar: 30))).to eq true

    expect(Feature::OrAttributes.enabled_for?(
      user: double(foo: 10, bar: 10))).to eq false
  end
end

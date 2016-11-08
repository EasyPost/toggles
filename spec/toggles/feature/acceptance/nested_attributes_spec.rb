describe "Feature::NestedAttributes" do
  specify do
    expect(Feature::NestedAttributes.enabled_for?(
        foo: double(bar: :two, baz: double(id: 51)))).to eq true
    expect(Feature::NestedAttributes.enabled_for?(
        foo: double(bar: :two, baz: double(id: 10)))).to eq true

    expect(Feature::NestedAttributes.enabled_for?(
        foo: double(bar: :one, baz: double(id: 51)))).to eq false
    expect(Feature::NestedAttributes.enabled_for?(
        foo: double(bar: :two, baz: double(id: 50)))).to eq false
  end
end

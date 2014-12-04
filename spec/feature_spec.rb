class Object
  def id; 1; end
  def success?; true; end
end

describe Feature do
  let(:object) { Object.new }

  specify do
    expect(Feature.new(object: {id: 1, success?: true})
                  .enabled_for?(object)).to eq true
    expect(Feature.new(object: {id: 1, success?: false})
                  .enabled_for?(object)).to eq false
  end

  specify "filename" do
    expect(Feature.new("test/default").enabled_for?(object)).to eq true
    expect(Feature.new("test/failure").enabled_for?(object)).to eq false
  end
end

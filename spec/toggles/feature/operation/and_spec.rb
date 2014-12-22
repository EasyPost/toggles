describe Feature::Operation::And do
  specify do
    [[60, true], [40, false], [80, false]].each do |(id, expected)|
      expect(
        described_class.call(double(id: id), :id, {"gt" => 50, "lt" => 70})
      ).to eq expected
    end
  end
end

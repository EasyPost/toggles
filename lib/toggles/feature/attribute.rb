class Feature::Attribute
  def self.call(entity, attr_name, expected)
    if expected.kind_of? Hash
      expected.all? do |operation, rules|
        if Feature.operations.include? operation.to_sym
          Feature.operations[operation.to_sym].call(entity, attr_name, rules)
        else
          call(entity.send(attr_name), operation, rules)
        end
      end
    else
      entity.send(attr_name) == expected
    end
  end
end

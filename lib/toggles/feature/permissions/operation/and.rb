module Feature
  class Permissions
    module Operation
      class And
        def self.call(entity, attr_name, expected)
          expected.all? do |operation, value|
            OPERATIONS.fetch(operation.to_sym, Attribute).call(
              entity, attr_name, value
            )
          end
        end
      end
    end
  end
end

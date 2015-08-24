module Feature
  module Operation
    class And
      def self.call(entity, attr_name, expected)
        expected.all? do |operation, value|
          if OPERATIONS.include? operation.to_sym
            OPERATIONS[operation.to_sym].call(entity, attr_name, value)
          else
            Operation::Attribute.call(entity, operation, value)
          end
        end
      end
    end
  end
end

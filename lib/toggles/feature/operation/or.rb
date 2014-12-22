module Feature
  module Operation
    class Or
      def self.call(entity, attr_name, expected)
        expected.any? do |operation, value|
          OPERATIONS[operation.to_sym].call(entity, attr_name, value)
        end
      end
    end
  end
end

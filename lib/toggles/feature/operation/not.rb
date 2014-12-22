module Feature
  module Operation
    class Not
      def self.call(entity, attr_name, expected)
        if expected.kind_of? Hash
          expected.none? do |operation, value|
            OPERATIONS[operation.to_sym].call(entity, attr_name, value)
          end
        else
          entity.send(attr_name) != expected
        end
      end
    end
  end
end

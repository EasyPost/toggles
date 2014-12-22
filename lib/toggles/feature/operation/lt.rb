module Feature
  module Operation
    class LessThan
      def self.call(entity, attr_name, expected)
        entity.send(attr_name) < expected
      end
    end
  end
end

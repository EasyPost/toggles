module Feature
  class Permissions
    module Operation
      class GreaterThan
        def self.call(entity, attr_name, expected)
          entity.send(attr_name) > expected
        end
      end
    end
  end
end

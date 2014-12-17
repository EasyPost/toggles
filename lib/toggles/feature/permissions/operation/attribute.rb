module Feature
  class Permissions
    module Operation
      class Attribute
        def self.call(entity, attr_name, expected)
          if expected.kind_of? Hash
            expected.all? do |operation, rules|
              if OPERATIONS.include? operation.to_sym
                OPERATIONS[operation.to_sym].call(entity, attr_name, rules)
              else
                Operation::Attribute.call(entity.send(attr_name), operation, rules)
              end
            end
          else
            entity.send(attr_name) == expected
          end
        end
      end
    end
  end
end

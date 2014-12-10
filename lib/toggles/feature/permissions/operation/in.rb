module Feature
  class Permissions
    module Operation
      class In
        def self.call(entity, attr_name, expected)
          if expected.kind_of? Hash
            expected = expected.reduce([]) do |list, (operation, args)|
              OPERATIONS[operation.to_sym].call(args)
            end
          end

          expected.include? entity.send(attr_name.to_sym)
        end
      end
    end
  end
end

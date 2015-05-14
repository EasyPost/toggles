require "find"

require "toggles/feature/base"
require "toggles/feature/operation"
require "toggles/feature/permissions"
require "toggles/feature/subject"

module Feature
  OPERATIONS = {and:   Operation::And,
                gt:    Operation::GreaterThan,
                in:    Operation::In,
                lt:    Operation::LessThan,
                not:   Operation::Not,
                or:    Operation::Or,
                range: Operation::Range}
end

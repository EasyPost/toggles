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

  @@tree = Module.new

  def self.set_tree(tree)
    @@tree = tree
  end

  def self.const_missing(sym)
    @@tree.const_get(sym, inherit: false)
  end

  def self.enabled?(sym, **criteria)
    @@tree.const_get(sym.to_s.split("_").map(&:capitalize).join(""), inherit: false)
      &.enabled_for?(criteria)
  end

  def self.disabled?(sym, **criteria)
    @@tree.const_get(sym.to_s.split("_").map(&:capitalize).join(""), inherit: false)
      &.disabled_for?(criteria)
  end
end

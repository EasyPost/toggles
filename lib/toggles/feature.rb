# frozen_string_literal: true
 
module Feature
  Error = Class.new(StandardError)
  Unknown = Class.new(Error)

  def self.features
    @features ||= {}
  end

  def self.operations
    @operations ||= {}
  end

  # @deprecated This is an abuse of lazy dispatch that creates cryptic errors
  def self.const_missing(sym)
    ConstantLookup.from(features, [:Feature]).const_missing(sym)
  end

  def self.enabled?(*sym, **criteria)
    sym
      .inject(features) { |a, e| a.fetch(e) }
      .enabled_for?(criteria)
  rescue KeyError
    raise Unknown, sym.inspect
  end

  def self.disabled?(*sym, **criteria)
    !enabled?(*sym, **criteria)
  end
end

require 'toggles/constant_lookup'
require "toggles/feature/base"
require "toggles/feature/attribute"
require "toggles/feature/permissions"
require "toggles/feature/subject"

Feature.operations[:and] = lambda { |entity, attr_name, expected|
  expected.all? do |operation, value|
    if Feature.operations.include? operation.to_sym
      Feature.operations[operation.to_sym].call(entity, attr_name, value)
    else
      Feature::Attribute.call(entity, operation, value)
    end
  end
}

Feature.operations[:in] = lambda { |entity, attr_name, expected|
  if expected.is_a? Hash
    expected = expected.reduce([]) do |_list, (operation, args)|
      Feature.operations[operation.to_sym].call(args)
    end
  end

  expected.include? entity.send(attr_name.to_sym)
}

Feature.operations[:not] = lambda { |entity, attr_name, expected|
  if expected.is_a? Hash
    expected.none? do |operation, value|
      Feature.operations[operation.to_sym].call(entity, attr_name, value)
    end
  else
    entity.send(attr_name) != expected
  end
}

Feature.operations[:or] = lambda { |entity, attr_name, expected|
  expected.any? do |operation, value|
    if Feature.operations.include? operation.to_sym
      Feature.operations[operation.to_sym].call(entity, attr_name, value)
    else
      Feature::Attribute.call(entity, operation, value)
    end
  end
}

Feature.operations[:gt] = ->(entity, attr_name, expected) { entity.send(attr_name) > expected }
Feature.operations[:lt] = ->(entity, attr_name, expected) { entity.send(attr_name) < expected }
Feature.operations[:range] = lambda { |args|
  raise StandardError, 'Invalid range operation' if args.size != 2

  (args.first..args.last)
}

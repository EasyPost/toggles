require "ostruct"
require "forwardable"
require 'yaml'

Feature::Permissions = Struct.new(:rules) do
  extend Forwardable

  def_delegators :rules, :all?, :keys

  def self.from_yaml(path)
    new(
      YAML.safe_load(File.read(path), permitted_classes: [Symbol])
    )
  end

  def subjects
    @subjects ||= keys.map(&:to_sym)
  end

  def valid_for?(entities)
    unless subjects == entities.keys
      raise Feature::Subject::Invalid, Feature::Subject.difference(subjects, entities.keys)
    end

    rules.all? do |name, rule|
      entity = entities[name.to_sym]

      if entity.nil?
        return false
      end

      if entity.class.ancestors.find { |ancestor| ancestor == Comparable }
        entity = OpenStruct.new(name => entity)
        rule   = {name => rule}
      end

      rule.all? do |key, value|
        Feature.operations.fetch(key.to_sym, Feature::Attribute).call(entity, key, value)
      end
    end
  end

  def enabled_for?(subjects = {})
    valid_for?(subjects)
  end

  def disabled_for?(subjects = {})
    !valid_for?(subjects)
  end
end

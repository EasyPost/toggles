require 'ostruct'
require 'forwardable'

class Feature::Permissions
  extend Forwardable

  attr_reader :rules

  def_delegators :rules, :all?, :keys

  def initialize(path)
    @rules = YAML.load(File.read(path))
  end

  def subjects
    @subjects ||= keys.map(&:to_sym)
  end

  def valid_for?(entities)
    raise Feature::Subject::Invalid, Feature::Subject.difference(subjects, entities.keys) unless subjects == entities.keys

    rules.all? do |name, rule|
      entity = entities[name.to_sym]

      return false if entity.nil?

      if entity.class.ancestors.find { |ancestor| ancestor == Comparable }
        entity = OpenStruct.new(name => entity)
        rule   = { name => rule }
      end

      rule.all? do |key, value|
        Feature.operations.fetch(key.to_sym, Feature::Attribute).call(entity, key, value)
      end
    end
  end
end

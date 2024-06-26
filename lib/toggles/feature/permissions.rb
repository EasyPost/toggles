require 'ostruct'
require 'forwardable'
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
    invalid_subjects = entities.keys - subjects
    if invalid_subjects.any?
      raise Feature::Subject::NotApplicable, invalid_subjects
    end

    subject_rules = rules.select { |name, _| entities.key?(name.to_sym) }

    raise Feature::Subject::Empty if subject_rules.empty?

    subject_rules
      .all? do |name, rule|
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

  def enabled_for?(subjects = {})
    valid_for?(subjects)
  end

  def disabled_for?(subjects = {})
    !valid_for?(subjects)
  end
end

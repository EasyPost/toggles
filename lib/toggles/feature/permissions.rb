require "ostruct"
require "toggles/feature/permissions/operation"

module Feature
  class Permissions
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
      unless subjects == entities.keys
        raise Subject::Invalid, Subject.difference(subjects, entities.keys)
      end

      rules.all? do |name, rule|
        entity = entities[name.to_sym]

        if entity.class.ancestors.find { |ancestor| ancestor == Comparable }
          entity = OpenStruct.new(name => entity)
          rule   = {name => rule}
        end

        rule.all? do |key, value|
          OPERATIONS.fetch(key, Operation::Attribute).call(entity, key, value)
        end
      end
    end
  end
end

require "toggles/feature/permissions/operation"

module Feature
  class Permissions
    extend Forwardable

    attr_reader :path

    def_delegators :rules, :all?, :keys

    def initialize(path)
      @path = path
    end

    def rules
      @rules ||= YAML.load(File.read(path))
    end

    def subjects
      @subjects ||= keys.map(&:to_sym)
    end

    def valid_for?(entities)
      unless subjects == entities.keys
        raise Subject::Invalid, Subject.difference(subjects, entities.keys)
      end

      rules.all? do |name, rule|
        rule.all? do |key, value|
          OPERATIONS.fetch(key, Operation::Attribute).call(
            entities[name.to_sym], key, value
          )
        end
      end
    end
  end
end

require "yaml"

module Feature
  class Base
    attr_reader :subjects, :rules

    def self.enabled_for?(*args)
      new(*args).enabled?
    end

    def self.disabled_for?(*args)
      !enabled_for?(*args)
    end

    def initialize(*args)
      @rules = Hash[args.map { |arg| [arg.class.name.downcase.to_sym, arg] }]
      @subjects = @rules.keys
    end

    def enabled?
      unless PERMISSIONS.subjects == subjects
        raise Subject::Invalid,
          Subject.difference(PERMISSIONS.subjects, subjects)
      end

      PERMISSIONS.all? do |name, permission|
        permission.all? do |key, value|
          rules[name.to_sym].send(key.to_sym) == value
        end
      end
    end
  end
end

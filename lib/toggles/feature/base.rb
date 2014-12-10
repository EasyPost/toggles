require "yaml"

module Feature
  class Base
    attr_reader :subjects

    def self.enabled_for?(subjects = {})
      new(subjects).enabled?
    end

    def self.disabled_for?(subjects = {})
      !enabled_for? subjects
    end

    def initialize(subjects)
      @subjects = subjects
    end

    def permissions
      @permissions ||= self.class::PERMISSIONS
    end

    def enabled?
      permissions.valid_for? subjects
    end
  end
end

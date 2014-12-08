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
  end
end

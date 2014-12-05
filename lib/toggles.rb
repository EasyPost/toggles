require "find"
require "yaml"

module Feature
  module Subject
    class Invalid < StandardError
      def initialize(args)
        super("Invalid subjects for permissions: #{args}")
      end
    end
  end

  class Base
    def self.permissions
      @permissions ||= YAML.load(File.read(@filename))
    end

    def self.enabled_for?(*args)
      subjects = Hash[args.map { |arg| [arg.class.name.downcase.to_sym, arg] }]

      if subjects.keys != permissions.keys.map(&:to_sym)
        raise Subject::Invalid,
          Set.new(subjects.keys - permissions.keys.map(&:to_sym) +
                  permissions.keys.map(&:to_sym) - subjects.keys).to_a
      end

      permissions.all? do |name, permission|
        permission.all? do |key, value|
          subjects[name.to_sym].send(key.to_sym) == value
        end
      end
    end

    def self.diabled_for?
      !enabled_for?
    end
  end
end

Find.find("features") do |filename|
  if filename.match(/\.ya?ml\Z/)
    *modules, cls = filename.chomp(File.extname(filename)).split("/")

    previous = Feature
    modules[1..-1].each do |directory|
      module_name = directory.split("_").map(&:capitalize).join.to_sym
      previous    = begin
                      previous.const_get(module_name)
                    rescue NameError
                      previous.const_set(module_name, Module.new)
                    end
    end

    c = Class.new(Feature::Base) do
      @filename = filename
    end
    previous.const_set(cls.split("_").map(&:capitalize).join.to_sym, c)
  end
end

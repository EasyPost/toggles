require "yaml"

class Feature
  attr_reader :permissions

  def initialize(permissions)
    @permissions ||= if permissions.kind_of?(String)
                       YAML.load(File.read("./features/#{permissions}.yml"))
                     else
                       permissions
                     end
  end

  def enabled_for?(*args)
    objects = Hash[args.map { |arg| [arg.class.name.downcase.to_sym, arg] }]

    permissions.all? do |name, permission|
      permission.all? { |key, value| objects[name].send(key) == value }
    end
  end
end

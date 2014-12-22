require "find"

require "toggles/feature/base"
require "toggles/feature/subject"
require "toggles/feature/operation"
require "toggles/feature/permissions"

module Feature
  OPERATIONS = {and:   Operation::And,
                gt:    Operation::GreaterThan,
                in:    Operation::In,
                lt:    Operation::LessThan,
                not:   Operation::Not,
                or:    Operation::Or,
                range: Operation::Range}
end

# Dynamically create modules and classes within the `Feature` module based on
# the directory structure of `features`.
#
# For example if the `features` directory has the structure:
#
# features
# ├── thing
# |   ├── one.yml
# |   └── two.yml
# └── test.yml
#
# `Feature::Test`, `Feature::Thing::One`, `Feature::Thing::Two` would be
# available by default.
#
# TODO: Make this configurable.
if File.directory?("features")
  Find.find("features") do |path|
    if path.match(/\.ya?ml\Z/)
      *directories, filename = path.chomp(File.extname(path)).split("/")

      previous = Feature
      directories[1..-1].each do |directory|
        module_name = directory.split("_").map(&:capitalize).join.to_sym
        previous    = begin
                        previous.const_get(module_name)
                      rescue NameError
                        previous.const_set(module_name, Module.new)
                      end
      end

      cls = Class.new(Feature::Base) do |c|
        c.const_set(:PERMISSIONS, Feature::Permissions.new(path))
      end

      previous.const_set(filename.split("_").map(&:capitalize).join.to_sym, cls)
    end
  end
end

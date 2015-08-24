require "toggles/configuration"
require "toggles/feature"

module Toggles
  extend self

  def configure
    yield configuration
    init
  end

  def configuration
    @configuration ||= Configuration.new
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
  def init
    return unless Dir.exists? configuration.features_dir

    Find.find(configuration.features_dir) do |path|
      if path.match(/\.ya?ml\Z/)
        _, *directories, filename = path.chomp(File.extname(path)).split("/")

        previous = Feature
        directories.each do |directory|
          module_name = directory.split("_").map(&:capitalize).join.to_sym
          previous    = if previous.constants.include? module_name
                          previous.const_get(module_name)
                        else
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
end

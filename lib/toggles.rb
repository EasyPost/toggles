require "find"
require "pathname"

require "toggles/configuration"
require "toggles/feature"

module Toggles
  extend self

  StatResult = Struct.new(:inode, :mtime)

  def configure
    @stat_tuple ||= StatResult.new(0, 0)
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

    new_tree = Module.new

    top_level = File.realpath(configuration.features_dir)
    top_level_p = Pathname.new(top_level)

    Find.find(top_level) do |path|
      previous = new_tree
      abspath = path
      path = Pathname.new(path).relative_path_from(top_level_p).to_s
      if path.match(/\.ya?ml\Z/)
        base = path.chomp(File.extname(path)).split("/")
        if base.size > 1
          directories = base[0...-1]
          filename = base[-1]
        else
          directories = []
          filename = base[0]
        end

        directories.each do |directory|
          module_name = directory.split("_").map(&:capitalize).join.to_sym
          previous    = if previous.constants.include? module_name
                          previous.const_get(module_name)
                        else
                          previous.const_set(module_name, Module.new)
                        end
        end

        cls = Class.new(Feature::Base) do |c|
          c.const_set(:PERMISSIONS, Feature::Permissions.new(abspath))
        end

        previous.const_set(filename.split("_").map(&:capitalize).join.to_sym, cls)
      end
    end

    stbuf = File.stat(top_level)
    @stat_tuple = StatResult.new(stbuf.ino, stbuf.mtime)

    Feature.set_tree(new_tree)
  end

  def reinit_if_changed
    # Reload the configuration if the top-level directory has changed.
    # Does not detect changes to files inside that directory unless your
    #
    return unless Dir.exists? configuration.features_dir
    top_level = File.realpath(configuration.features_dir)
    stbuf = File.stat(top_level)
    stat_tuple = StatResult.new(stbuf.ino, stbuf.mtime)

    if @stat_tuple != stat_tuple
      init
    end
  end
end

require 'find'
require 'pathname'
require 'set'

require 'toggles/version'

require 'toggles/configuration'
require 'toggles/feature'

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

  def init
    return unless Dir.exist? configuration.features_dir

    top_level = File.realpath(configuration.features_dir)
    top_level_p = Pathname.new(top_level)

    Feature.features.clear

    Dir[File.join(top_level, '**/*.{yaml,yml}')].each do |abspath|
      path = Pathname.new(abspath).relative_path_from(top_level_p).to_s
      features = path.split('/')[0..-2].inject(Feature.features) { |a, e| a[e.to_sym] ||= {} }
      feature_key = File.basename(path, File.extname(path)).to_sym
      features[feature_key] = Feature::Permissions.from_yaml(abspath)
    end

    stbuf = File.stat(top_level)
    @stat_tuple = StatResult.new(stbuf.ino, stbuf.mtime)
  end

  def reinit_if_changed
    # Reload the configuration if the top-level directory has changed.
    # Does not detect changes to files inside that directory unless your
    # filesystem propagates mtimes.
    return unless Dir.exist? configuration.features_dir

    top_level = File.realpath(configuration.features_dir)
    stbuf = File.stat(top_level)
    stat_tuple = StatResult.new(stbuf.ino, stbuf.mtime)

    init if @stat_tuple != stat_tuple
  end
end

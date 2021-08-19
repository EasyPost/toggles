class Feature::ConstantLookup
  Error = Class.new(NameError) do
    attr_reader :sym

    def initialize(sym)
      @sym = sym
      super(sym.join('::'))
    end
  end

  # Return a tree walker that translates Module#const_missing(sym) into the next child node
  #
  # So Features::Cat::BearDog walks as:
  # * next_features = Feature.features # root
  # * const_missing(:Cat) => next_features = next_features['cat']
  # * const_missing(:BearDog) => next_features['bear_dog']
  # * const_missing(:CN22) => next_features['c_n_22']
  #
  # Defined at Toggles.features_dir + "/cat/bear_dog.yaml"
  #
  # @raise [Error] if constant cannot be resolved
  def self.from(features, path)
    Class.new {
      class << self
        attr_accessor :features, :path

        def const_missing(sym)
          # translate class name into path part i.e :BearDog #=> 'bear_dog'
          key = sym.to_s
          key.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
          key.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
          key.downcase!

          subtree_or_feature = features.fetch(key.to_sym)

          if subtree_or_feature.is_a?(Hash)
            Feature::ConstantLookup.from(subtree_or_feature, path + [sym])
          else
            subtree_or_feature
          end
        rescue KeyError
          raise Error, path + [sym]
        end
      end
    }.tap do |resolver|
      resolver.features = features
      resolver.path = path
    end
  end
end

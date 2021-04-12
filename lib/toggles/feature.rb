require "toggles/feature/base"
require "toggles/feature/operation"
require "toggles/feature/permissions"
require "toggles/feature/subject"

module Feature
  OPERATIONS = {and:   Operation::And,
                gt:    Operation::GreaterThan,
                in:    Operation::In,
                lt:    Operation::LessThan,
                not:   Operation::Not,
                or:    Operation::Or,
                range: Operation::Range}

  def self.features
    @features ||= {}
  end

  class Lookup
    Error = Class.new(StandardError) do
      attr_reader :sym

      def initialize(sym)
        @sym = sym
        super(sym.join('::'))
      end
    end

    def self.from(features, path)
      Class.new do
        class << self
          attr_accessor :features
          attr_accessor :path

          def const_missing(sym)
            subtree_or_feature = features.fetch(
              sym.to_s.gsub(/([a-z])([A-Z])/) { |s| s.chars[0] + "_" + s.chars[1] }.downcase.to_sym,
            )
            if subtree_or_feature.is_a?(Hash)
              Lookup.from(subtree_or_feature, path + [sym])
            else
              subtree_or_feature
            end
          rescue KeyError
            raise Lookup::Error.new(path + [sym])
          end
        end
      end.tap do |lookup|
        lookup.features = features
        lookup.path = path
      end
    end
  end

  # @deprecated This is an abuse of lazy dispatch that creates cryptic errors
  def self.const_missing(sym)
    Lookup.from(features, [:Feature]).const_missing(sym)
  end

  def self.enabled?(sym, **criteria)
    features.fetch(sym).enabled_for?(criteria)
  end

  def self.disabled?(sym, **criteria)
    features.fetch(sym).disabled_for?(criteria)
  end
end

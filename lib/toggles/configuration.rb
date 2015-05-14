module Toggles
  class Configuration
    def features_dir=(dir)
      @features_dir = dir
    end

    def features_dir
      @features_dir ||= "features"
    end
  end
end

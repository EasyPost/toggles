require "rspec/its"

require "toggles"

Toggles.configure do |config|
  config.features_dir = "features"
end

RSpec.configure do |config|
  config.order = "random"
end

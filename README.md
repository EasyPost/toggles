# Toggles

[![Gem Version](https://badge.fury.io/rb/toggles.svg)](https://badge.fury.io/rb/toggles)

YAML backed feature toggles

## Installation

Add the following to your Gemfile:

```ruby
gem "toggles"
```

and run `bundle install` from your shell.

To install the gem manually from your shell, run:

```ruby
gem install toggles
```

## Configuration

Configure `toggles`:

```ruby
Toggles.configure do |config|
  config.features_dir = "features"
end
```

You can now express conditional logic within `features_dir`. The structure of the `features_dir` determines the structure of the classes within the `Feature` module. For example if the `features_dir` has the structure:

```
features
├── thing
|   ├── one.yml
|   └── two.yml
└── test.yml
```

The classes `Feature::Test`, `Feature::Thing::One` and `Feature::Thing::Two` will be available for use within your application.

## Usage

Create a file in `features_dir`:

```yaml
user:
  id:
    in:
      - 12345
      - 54321
```

Check if the feature is enabled or disabled:

```ruby
Feature::NewFeature::AvailableForPresentation.enabled_for?(user: OpenStruct.new(id: 12345)) # true
Feature::NewFeature::AvailableForPresentation.enabled_for?(user: OpenStruct.new(id: 54321)) # true
Feature::NewFeature::AvailableForPresentation.enabled_for?(user: OpenStruct.new(id: 7)) # false

Feature::NewFeature::AvailableForPresentation.disabled_for?(user: OpenStruct.new(id: 12345)) # false
Feature::NewFeature::AvailableForPresentation.disabled_for?(user: OpenStruct.new(id: 54321)) # false
Feature::NewFeature::AvailableForPresentation.disabled_for?(user: OpenStruct.new(id: 7)) # true
```

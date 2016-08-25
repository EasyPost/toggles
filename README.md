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

## Usage

Configure `toggles`:

```ruby
Toggles.configure do |config|
  config.features_dir = "features"
end
```

You can now express conditional logic as a DSL within YAML files within `features_dir`. For example if you wanted to limit a user's access to specific features until they contributed enough to the site we could create a feature. The rules are that once you've posted more than 10 times or commented on a post more 20 times you can then upvote other user's posts or comments. To do this we create a feature in the file `features/user/upvote.yml`.

```yaml
user:
  or:
    posts:
      gt: 10
    comments:
      gt: 20
```

You can now check if the feature is enabled by running:

```ruby
Feature::User::Upvote.enabled_for?(user: OpenStruct.new(posts: 5, comments: 30)) # true
Feature::User::Upvote.enabled_for?(user: OpenStruct.new(posts: 15, comments: 15)) # true
Feature::User::Upvote.enabled_for?(user: OpenStruct.new(posts: 5, comments: 15)) # false

Feature::User::Upvote.disabled_for?(user: OpenStruct.new(posts: 5, comments: 30)) # false
Feature::User::Upvote.disabled_for?(user: OpenStruct.new(posts: 15, comments: 15)) # false
Feature::User::Upvote.disabled_for?(user: OpenStruct.new(posts: 5, comments: 15)) # true
```

The structure of the `features_dir` determines the structure of the classes within the `Feature` module. For example if the `features_dir` has the structure:

```
features
├── thing
|   ├── one.yml
|   └── two.yml
└── test.yml
```

The classes `Feature::Test`, `Feature::Thing::One` and `Feature::Thing::Two` will be available for use within your application.

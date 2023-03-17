## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## build - Builds the project
build:
	gem build toggles.gemspec --strict
	mkdir -p dist
	mv *.gem dist/

## clean - Cleans the project
clean:
	rm -rf *.gem dist

## install - Install globally from source
install:
	bundle install

## publish - Publishes the built gem to Rubygems
publish:
	gem push dist/*.gem

## release - Cuts a release for the project on GitHub (requires GitHub CLI)
# tag = The associated tag title of the release
release:
	gh release create ${tag} dist/*

## test - Test the project (and ignore warnings for test output)
test:
	bundle exec rspec

.PHONY: help build clean install publish release test

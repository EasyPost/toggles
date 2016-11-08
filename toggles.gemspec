Gem::Specification.new do |s|
  s.name = "toggles"
  s.version = "0.1.2"
  s.authors = ["Andrew Tribone", "James Brown"]
  s.summary = "YAML backed feature toggles"
  s.email = "oss@easypost.com"
  s.homepage = "https://github.com/EasyPost/toggles"
  s.license = "ISC"
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(/^(spec)\//)

  s.add_development_dependency "bundler"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "rspec-temp_dir"
end

# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{howl}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Clinton R. Nixon"]
  s.date = %q{2010-10-15}
  s.description = %q{Howl is a tiny static website/blog generator.}
  s.email = %q{crnixon@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/howl.rb",
     "test/fixtures/pages/has_template.html",
     "test/fixtures/pages/no_yaml.html",
     "test/fixtures/pages/simple.html",
     "test/fixtures/site/has_template.html",
     "test/fixtures/site/no_yaml.html",
     "test/fixtures/site/simple.html",
     "test/fixtures/templates/alt.html",
     "test/fixtures/templates/default.html",
     "test/fixtures/templates/site.html",
     "test/howl_test.rb",
     "test/teststrap.rb"
  ]
  s.homepage = %q{http://github.com/crnixon/howl}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A tiny static website/blog generator.}
  s.test_files = [
    "test/howl_test.rb",
     "test/teststrap.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<riot>, [">= 0.11"])
      s.add_runtime_dependency(%q<rdiscount>, [">= 0"])
      s.add_runtime_dependency(%q<mustache>, [">= 0"])
    else
      s.add_dependency(%q<riot>, [">= 0.11"])
      s.add_dependency(%q<rdiscount>, [">= 0"])
      s.add_dependency(%q<mustache>, [">= 0"])
    end
  else
    s.add_dependency(%q<riot>, [">= 0.11"])
    s.add_dependency(%q<rdiscount>, [">= 0"])
    s.add_dependency(%q<mustache>, [">= 0"])
  end
end

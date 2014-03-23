# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "on_a_ladder"
  spec.version       = `cat VERSION`
  spec.authors       = ["da99"]
  spec.email         = ["i-hate-spam-1234567@mailinator.com"]
  spec.summary       = %q{A Ruby gem to generate SQL dealing with parent-child-grandchild records.}
  spec.description   = %q{
    A gem that uses the i_dig_sql gem to generate SQL
    strings. You can it an instance and it generates the
    SQL to find its ancestors:
    Example: page -> chapter -> book -> library
  }
  spec.homepage      = "https://github.com/da99/on_a_ladder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bacon"
  spec.add_development_dependency "Bacon_Colored"
end

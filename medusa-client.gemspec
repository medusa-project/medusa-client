lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "medusa/version"

Gem::Specification.new do |spec|
  spec.name       = "medusa-client"
  spec.version    = Medusa::VERSION
  spec.authors    = ["Alex Dolski"]
  spec.email      = ["alexd@illinois.edu"]

  spec.summary    = "Client for the UIUC Library's Medusa preservation repository"
  spec.homepage   = "https://github.com/medusa-project/medusa-client"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/medusa-project/medusa-client.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httpclient'
  spec.add_development_dependency 'rake', "~> 12.0"
  spec.add_development_dependency 'minitest', "~> 5.0"
  spec.add_development_dependency 'yard'
end

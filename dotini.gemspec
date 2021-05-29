# frozen_string_literal: true

require_relative 'lib/dotini/version'

Gem::Specification.new do |spec|
  spec.name          = 'dotini'
  spec.version       = Dotini::VERSION
  spec.authors       = ['Wendel Scardua']
  spec.email         = ['wendelscardua@gmail.com']

  spec.summary       = 'Read and write INI files'
  spec.description   = 'Parser and generator of INI files'
  spec.homepage      = 'https://github.com/wendelscardua/dotini'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rubocop', '~> 1.15'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end

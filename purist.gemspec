# frozen_string_literal: true

require_relative 'lib/purist/version'

Gem::Specification.new do |spec|
  spec.name        = 'purist'
  spec.version     = Purist::VERSION
  spec.summary     = 'Automatic runtime impure ruby methods invocation detection'
  spec.description = <<~TXT
    Automatic runtime impure ruby methods invocation detection by tracing predifined
    Ruby stdlib and core libs methods via `tracepoint` API
  TXT
  spec.authors = ['Yaroslav Kurbatov']
  spec.required_ruby_version = '>= 2.7.0'
  spec.email = 'iaroslav2k@gmail.com'
  spec.homepage = 'https://github.com/viralpraxis/purist'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "#{spec.homepage}/tree/main"
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z lib`.split("\x0")
  end

  spec.extra_rdoc_files = %w[README.md LICENSE.txt]
end

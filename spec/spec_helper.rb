# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  enable_coverage_for_eval
end

require 'purist'
require 'purist/integrations/rspec'

require 'rspec/matchers/fail_matchers'
require 'rspec/its'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.raise_errors_for_deprecations!

  config.disable_monkey_patching!

  config.include RSpec::Matchers::FailMatchers
  config.include Purist::Integrations::RSpec::Matchers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

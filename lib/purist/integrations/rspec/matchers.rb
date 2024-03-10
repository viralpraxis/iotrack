# frozen_string_literal: true

require_relative 'be_pure'
require_relative 'be_impure'

module Purist
  module Integrations
    module RSpec
      module Matchers
        def be_pure
          BePure.new
        end
      end
    end
  end
end

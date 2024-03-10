# frozen_string_literal: true

RSpec.describe Purist::Integrations::RSpec::Matchers do
  describe '#be_pure' do
    context 'with pure block' do
      it { expect { 1 + 1 }.to be_pure }
      it { expect { Class.new }.to be_pure }

      # rubocop:disable RSpec/MultipleExpectations
      specify do
        expect do
          expect { 1 + 1 }.not_to be_pure
        end.to fail_with('expected block to be impure, but no side-effects were detected')
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'with impure block' do
      it { expect { p 1 }.not_to be_pure }
      it { expect { Kernel.puts 1 }.not_to be_pure }

      # rubocop:disable RSpec/MultipleExpectations
      specify do
        expect do
          expect { p 1 }.to be_pure
        end.to fail_with(/expected block to be pure, detected impure .+/)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    # rubocop:disable RSpec/MultipleExpectations
    context 'with expectation on value' do
      it 'raises exception' do
        expect { expect(1).to be_pure }
          .to raise_error(RSpec::Core::DeprecationError, /The implicit block expectation syntax is deprecated/)
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#be_impure' do
    context 'with pure block' do
      it { expect { 1 + 1 }.not_to be_impure }
      it { expect { Class.new }.not_to be_impure }

      # rubocop:disable RSpec/MultipleExpectations
      specify do
        expect do
          expect { 1 + 1 }.to be_impure
        end.to fail_with('expected block to be impure, but no side-effects were detected')
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'with impure block' do
      it { expect { p 1 }.to be_impure }
      it { expect { require 'securerandom' }.to be_impure }

      # rubocop:disable RSpec/MultipleExpectations
      specify do
        expect do
          expect { p 1 }.not_to be_impure
        end.to fail_with(/expected block to be pure, detected impure .+/)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end
end

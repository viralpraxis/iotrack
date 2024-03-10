# frozen_string_literal: true

RSpec.describe Purist::Handler do
  describe '.build' do
    def perform(mode)
      described_class.build(mode)
    end

    it { expect(perform(:raise)).to be_an_instance_of(described_class::Raise) }
    it { expect(perform(nil)).to be_nil }

    specify do
      expect { perform(:warn) }.to raise_error(ArgumentError, 'Unexpected mode `:warn`')
    end
  end
end

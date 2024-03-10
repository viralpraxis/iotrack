# frozen_string_literal: true

RSpec.describe Purist::Configuration do
  describe '#action_on_purity_violation' do
    it { expect(described_class.instance.action_on_purity_violation).to eq(:raise) }
  end
end

require 'spec_helper'
require 'currency_calculator'
require 'parsers/json_parser'

RSpec.describe CurrencyCalculator do
  context 'when from currency value is 0' do
    class Parsers::MockParser < Parsers::Base
      def initialize(base:)
        @base = base
      end

      def find_by!(currency:, date:)
        Rate.new(0.0)
      end
    end

    subject { described_class.new(parser: Parsers::MockParser.new(base: 'EUR')) }

    it 'raises a FailToCalculateRate error' do
      expect{
        subject.calculate_rate(from: "GBP", to: "EUR", date: Date.new(2018,11,22))
      }.to raise_error(CurrencyCalculator::FailToCalculateRate)
    end
  end

  context 'when from currency value is not 0' do
    subject { described_class.new(parser: Parsers::JsonParser.new(base: 'EUR')) }
    let(:expected_rate) { 1.1286936499695253 }

    it 'calculates the rate' do
      expect(subject.calculate_rate(from: "GBP", to: "EUR", date: Date.new(2018,11,22))).to eq(expected_rate)
    end
  end
end
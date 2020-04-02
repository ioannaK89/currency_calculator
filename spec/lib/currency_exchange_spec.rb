require 'spec_helper'
require 'currency_exchange'

RSpec.describe CurrencyExchange do
  let(:date) { Date.new(2018,11,22) }

  context 'when no date for the date provided' do
    let(:invalid_date) { Date.new(2020,4,8) }

    it 'raises a RateNotFound error' do
      expect{ CurrencyExchange.rate(invalid_date, "GBP", "USD")} .to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when unable to calculate requested rate' do
    it 'raises a RateNotFound error' do
      expect{ CurrencyExchange.rate(date, "INVALID", "USD")} .to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when base does not exist' do
    it 'raises a RateNotFound error' do
      expect{ CurrencyExchange.rate(date, "GBP", "USD", "INVALID")} .to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when cannot calculate error' do
    class Parsers::MockParser < Parsers::Base
      def find_by!(currency:, date:)
        Rate.new(0.0)
      end
    end

    it 'returns the expected rate' do
      expect{ CurrencyExchange.rate(date, "GBP", "USD", "EUR", Parsers::MockParser)} .to raise_error(CurrencyCalculator::FailToCalculateRate)
    end
  end

  context 'with non base currency exchange' do
    let(:expected_rate) { 1.2870493690602498 }

    it 'returns the expected rate' do
      expect(CurrencyExchange.rate(date, "GBP", "USD")).to eq(expected_rate)
    end
  end

  context 'with base currency rate' do
    let(:expected_rate) { 0.007763975155279502 }

    it 'returns the expected rate' do
      expect(CurrencyExchange.rate(date, "JPY", "EUR")).to eq(expected_rate)
    end
  end
end
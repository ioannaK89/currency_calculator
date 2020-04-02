require 'spec_helper'

RSpec.describe Parsers::JsonParser do
  context 'when rate does not exist in file' do
    subject { described_class.new(base: 'USD') }

    it 'raises a RateNotFound error' do
      expect{
        subject.find_by!(currency: 'EUR', date: Date.new(2018,5,5))
      }.to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when date does not exist' do
    subject { described_class.new(base: 'EUR') }

    it 'raises a RateNotFound error' do
      expect{
        subject.find_by!(currency: 'USD', date: Date.new(2020,5,5))
      }.to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when currency does not exist' do
    subject { described_class.new(base: 'EUR') }

    it 'raises a RateNotFound error' do
      expect{
        subject.find_by!(currency: 'INVALID', date: Date.new(2020,5,5))
      }.to raise_error(Parsers::RateNotFound)
    end
  end

  context 'when rate can be found' do
    subject { described_class.new(base: 'EUR') }

    it 'returns the rate' do
      expect(subject.find_by!(currency: 'USD', date: Date.new(2018,11,22))).to eq(Parsers::Base::Rate.new(1.1403))
    end
  end
end
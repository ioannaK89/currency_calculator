require 'json'
require_relative 'base'

module Parsers
  class JsonParser < Base
    PATH_FILES = {
      'EUR' => File.expand_path("../../../data/eurofxref-hist-90d.json", __FILE__).freeze
    }

    def find_by!(currency:, date:)
      return Rate.new(1.0) if currency == @base

      rates_for_date = data[date.to_s]
      raise RateNotFound unless rates_for_date

      rate_for_currency = rates_for_date[currency]
      raise RateNotFound unless rate_for_currency
  
      Rate.new(rate_for_currency.to_f)
    end
  
    private

    def data
      @data ||= JSON.load(file)
    end

    def file
      raise RateNotFound unless PATH_FILES[@base]

      File.open(PATH_FILES[@base])
    end
  end
end
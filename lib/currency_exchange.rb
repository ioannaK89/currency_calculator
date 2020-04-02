require_relative 'currency_calculator'
require_relative 'parsers/json_parser'

module CurrencyExchange

  # Return the exchange rate between from_currency and to_currency on date as a float.
  # Raises an exception if unable to calculate requested rate.
  # Raises an exception if there is no rate for the date provided.

  class << self
    def rate(date, from_currency, to_currency, base='EUR', parser_class=Parsers::JsonParser)
      calculator = CurrencyCalculator.new(parser: parser_class.new(base: base))
      calculator.calculate_rate(from: from_currency, to: to_currency, date: date)
    end
  end
end

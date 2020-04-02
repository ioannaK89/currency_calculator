class CurrencyCalculator
  class FailToCalculateRate < StandardError; end

  attr_reader :parser

  def initialize(parser:)
    @parser = parser
  end

  def calculate_rate(from:, to:, date:)
    from_rate = parser.find_by!(currency: from, date: date)
    to_rate = parser.find_by!(currency: to, date: date)

    raise FailToCalculateRate if from_rate.value == 0

    to_rate.value / from_rate.value
  end
end
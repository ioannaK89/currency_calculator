module Parsers
  class RateNotFound < StandardError; end

  class Base
    class Rate < Struct.new(:value); end

    def initialize(base:)
      @base = base
    end

    def find_by!(currency:, date:)
      raise NotImplementedError
    end
  end
end
## Setup and Run Instructions

I have used rspec for my tests, so running the specs is the only different step.

1. Install gems:

```
bundle install
```

2. Run tests:

```
bundle exec rspec
```

3. Start a console session:

```
bundle exec irb -Ilib
```

4. Load Date librady:
```
require 'date'
```

5. Load the template library:

```
require 'currency_exchange'
```

6. Calculate an exchange rate:

```
CurrencyExchange.rate(Date.new(2018, 11, 22), "USD", "GBP")
```

## Your Design Decisions

My design decisions were based on the fact that in the future we want to use other sources for rates than JSON file and base currency may not be based on the EUR.

### Structure

I have tried to keep things as SOLID as possible. The currency exchange essentially encapsulates the public interface for computing rates. That class delegates the calculation of a rate to a class responsible for that, called CurrencyCalculator. The CurrencyCalculator is using an injected single responsible parser object that is responsible for giving us rates for a given currency under a specific base on a given date.

### Different Sources

Supporting different sources of data, comes with ease. That is because the currency calculator is designed to use injected parsers that behave the same way, making the currency calculator open-closed.

If we assume that in the future there is a need to fetch rates from an external API, it would be simply a matter of creating a new parser i.e. `Parsers::APIParser`, that complies with the parser API by defining the find_by! method and inheriting the base parser. None of the currency calculator or currency exchange needs to change (excluding the new parser passed as reference). For example:

```
CurrencyExchange.rate(date, from_currency, to_currency, "EUR", Parsers::APIParser)
```

### Different Currency Base

I have added the argument `base` as an optional argument with default value `EUR` to CurrencyExchange.rate method. If we want to have a different currency base we can do this by passing a new base, for example:

```
CurrencyExchange.rate(date, from_currency, to_currency, "USD")
```

### Assumptions and Clarifications

- I assumed that the based rate will be an upcased string, hence i didnt add any normalization to that input.
- In case that a base rate cant be found i raised an exception.

# InvestSim

A simple tool to simulate stock market returns using S&P 500 data from January 1871 through today

# Usage

1. Load libraries:

```ruby
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "data")
require 'investsim'
```

2. Parse data from Robert Shiller's S&P 500 spreadsheet:

```ruby
data_table = ShillerParser.new.data_table
```

3. Create an investment account; optionally load with an initial investment:

```ruby
account = InvestmentAccount.new(data_table, {amount: 100})
```

4. Manipulate the account through investment, withdrawal, or no action through each month

```ruby
account.invest_and_advance 10
account.withdraw_and_advance 10
account.advance
account.advance_to account.last_date
```

5. Check account balance at any point

```ruby
puts account.balance
```

# Current Scripts

`scripts/trinity_extended` analyzes stock market portfolio success probabilities for different drawdown terms and withdrawal rates. The script also provides for optional adjustable expense ratio and toggling between monthly and annual withdrawals

# Contributing

This tool was scraped together by @chrisdurheim and could use some TLC. I may do some updates on my own, but if you'd like to get involved, let me know.

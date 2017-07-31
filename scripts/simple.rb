$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "data")
require 'investsim'

data_table = ShillerParser.new.data_table

puts "Investing $100 in Jan 1871"

account = InvestmentAccount.new(data_table, {amount: 100})

puts account

account.advance_to(account.last_date)

puts account

# Shows today's value of an investment of $100 in Jan 1871

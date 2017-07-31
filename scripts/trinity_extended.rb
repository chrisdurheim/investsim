$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "data")
require 'investsim'
require 'spreadsheet'
require 'descriptive_statistics'
require_relative './trinity_extended/output.rb'

data_table = ShillerParser.new.data_table

# Setup
drawdown_durations = [10, 20, 30, 40, 50, 60, 70].collect { |n| n * 12 }
withdrawal_rates = [0.025, 0.03, 0.035, 0.04, 0.045, 0.05, 0.055, 0.06]

# Scenario Settings
expense_ratio = (1 + 0.04 / 100.0) ** (1.0/12.0) - 1 # Converted to monthly rate
monthly_withdrawal = true # If false, withdrawals are taken annually

# Build results array of drawdown duration and withdrawl rate combinations
results = drawdown_durations.map do |drawdown_duration|

  ## Gather scenarios with sufficient data
  time_span = 0..(data_table.count - drawdown_duration - 1)

  withdrawal_rates.map do |withdrawal_rate|

    puts "#{drawdown_duration} months at #{withdrawal_rate * 100}%"

    # Gather outcomes for given drawdown/withdrawal rate combination
    outcomes = time_span.map do |starting_period|
      account = InvestmentAccount.new(data_table, {date_index: starting_period, amount: 1000000})
      starting_cpi = data_table[starting_period].cpi

      base_withdrawal = account.balance * withdrawal_rate / 12

      drawdown_duration.times do |period|
        if monthly_withdrawal
          withdrawal = base_withdrawal * data_table[starting_period + period].cpi / starting_cpi
        else # Annual withdrawal
          proposed_withdrawal = base_withdrawal * 12 * data_table[starting_period + period].cpi / starting_cpi
          withdrawal = period % 12 == 0 ? proposed_withdrawal : 0
        end

        expense_load = account.balance * expense_ratio

        account.withdraw_and_advance(withdrawal + expense_load)

        if account.balance <= 0
          puts "Failed out: #{data_table[starting_period].date}"
          break
        end
      end

      [account.balance, 0].max
    end
  end
end

# Output results
output_html(results, monthly_withdrawal, expense_ratio, drawdown_durations, withdrawal_rates)

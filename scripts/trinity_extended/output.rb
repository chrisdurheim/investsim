def output_csv(results, monthly_withdrawal, expense_ratio, drawdown_durations, withdrawal_rates)
  puts "#{monthly_withdrawal ? 'Monthly' : 'Annual'} withdrawal; Expense ratio: #{((expense_ratio + 1) ** 12 - 1)}%"
  puts "," + withdrawal_rates.join(",")

  drawdown_durations.count.times do |dd_index|
    print "#{drawdown_durations[dd_index] / 12},"
    withdrawal_rates.count.times do |wr_index|
      out = results[dd_index][wr_index]
      analyzed_periods = out.count
      successful_periods = out.count { |outcome| outcome > 0 }
      success = successful_periods / (1.0 * analyzed_periods)

      print "#{success},"
    end
    puts ""
  end
end

def output_html(results, monthly_withdrawal, expense_ratio, drawdown_durations, withdrawal_rates)
  puts "<div class=\"responsive__table__container\">"
  puts "<table>"
  title = "#{monthly_withdrawal ? 'Monthly' : 'Annual'} withdrawal; Expense ratio: #{(((expense_ratio + 1) ** 12 - 1)*100).round(2)}%"
  puts "<tr><th colspan=\"#{withdrawal_rates.count + 1}\">#{title}</th></tr>"
  puts "<tr><th rowspan=\"2\">Payout Period (years)</th><th colspan=\"#{withdrawal_rates.count}\">Inflation-Adjusted Annual Withdrawal as % of Initial Value</th></tr>"
  print "<tr>"
  withdrawal_rates.each do |rate|
    print "<th>#{(rate * 100).round(1)}%</th>"
  end
  puts "</tr>"

  drawdown_durations.count.times do |dd_index|
    print "<tr><th>#{drawdown_durations[dd_index] / 12}</th>"
    withdrawal_rates.count.times do |wr_index|
      out = results[dd_index][wr_index]
      analyzed_periods = out.count
      successful_periods = out.count { |outcome| outcome > 0 }
      success = successful_periods / (1.0 * analyzed_periods)

      print "<td>#{(success * 100).round(1)}%</td>"
    end
    puts "</tr>"
  end
  puts "</table>"
  puts "</div>"
end

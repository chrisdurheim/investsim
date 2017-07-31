class InvestmentAccount

  attr_reader :shares

  def initialize(market_data, options = {})
    @market_data = market_data
    @date_index = options[:date_index] || 0
    @shares = (options[:amount] || 0) / current_price_per_share
  end

  def current_date
    @market_data[@date_index].date
  end

  def balance
    @shares * current_price_per_share
  end

  def invest_and_advance(amount)
    advance(amount)
  end

  def withdraw_and_advance(amount)
    advance(-amount)
  end

  def collect_dividends
    @shares += @shares * current_dividend_per_share / current_price_per_share
  end

  def advance(amount)
    @date_index += 1
    collect_dividends
    @shares += amount / current_price_per_share
  end

  def current_price_per_share
    @market_data[@date_index].price_per_share
  end

  def current_dividend_per_share
    @market_data[@date_index].dividend_per_share / 12
  end

  def to_s
    "#{current_date}: #{@shares} shares at #{current_price_per_share} = #{balance}"
  end

  def advance_to(end_index)
    advance_by(end_index - @date_index)
  end

  def advance_by(count)
    count.times { advance(0) }
  end

  def last_date
    @market_data.size - 1
  end
end

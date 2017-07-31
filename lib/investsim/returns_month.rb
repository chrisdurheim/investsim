class ReturnsMonth
  attr_reader :date, :price_per_share, :dividend_per_share, :cpi

  def initialize(date, price, dividend, cpi)
    @date = date
    @price_per_share = price
    @dividend_per_share = dividend
    @cpi = cpi
  end
end

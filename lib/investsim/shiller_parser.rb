require 'spreadsheet'
require 'investsim/returns_month'

class ShillerParser

  attr_reader :data_table

  DEFAULT_DATA = Pathname.new(__FILE__) + '../../../data/ie_data.xls'

  def initialize(file_path = DEFAULT_DATA)
    Spreadsheet.client_encoding = 'UTF-8'

    book = Spreadsheet.open file_path

    data_sheet = book.worksheet 'Data'

    headers = data_sheet.row 7

    # Downselect to rows with complete data (dividend is present)
    valid_data = data_sheet.select { |row| (row[2].is_a? Numeric) || (row[2].is_a? Spreadsheet::Formula) }

    @data_table = valid_data[0..-1].map do |row|
      date = row[5].value
      price = row[1]
      dividend = row[2].class == Spreadsheet::Formula ? row[2].value : row[2]
      cpi = row[4].class == Spreadsheet::Formula ? row[4].value : row[4]

      ReturnsMonth.new date, price, dividend, cpi
    end
  end
end

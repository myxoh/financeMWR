require 'test_helper'
require 'helpers/financial_test_helper'
include FinancialTestHelper

class FinancialAPITest < ActiveSupport::TestCase
  setup do
    @client = FinancialAPI.new(sleep_time: 0)
    basic_api_setup
  end


  test "aapl quote" do
    stock = @client.quote(@symbol)
    assert stock.price = 139.78
  end

  test "apple lookup" do
    stocks = @client.lookup(@value)
    stock = stocks.first
    assert stock.symbol == @symbol
    assert stock.exchange == "NASDAQ"
    assert stock.name == "Apple Inc"
  end

  test "multiple single quotes (stocks)" do
    stocks = [Ticket.new(symbol: @symbol),
      Ticket.new(symbol: 'APLE')]
    stocks = @client.multiple_single_quotes(stocks)
    assert stocks.first.price  == 139.78
    assert stocks.second.price == 19.06
  end

  test "multiple single quotes (symbols)" do
    stocks = ['AAPL', 'APLE']
    stocks = @client.multiple_single_quotes(stocks)
    assert stocks.first.price  == 139.78
    assert stocks.second.price == 19.06
  end


  test "use different api" do
    stub_quote(@symbol, 'http://another.api.com/quote')
    client = FinancialAPI.new(endpoint: 'http://another.api.com/', quote:'quote')
    stock = client.quote(@symbol)
    assert stock.price = 139.78
  end

end
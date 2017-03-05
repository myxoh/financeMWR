require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Can create" do
    watchlist = Watchlist.new(symbol: "GOOG")
    assert watchlist.save
  end

  test "UPPER CASE" do
    watchlist = Watchlist.create(symbol: "goog")
    assert watchlist.symbol == 'GOOG'
  end

  test "unique" do
    watchlist = Watchlist.new(symbol: 'AAPL')
    assert_not watchlist.save
    watchlist = Watchlist.new(symbol: 'aapl')
    assert_not watchlist.save
  end
end

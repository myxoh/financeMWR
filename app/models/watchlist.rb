class Watchlist < ApplicationRecord
  validates :symbol, :uniqueness => true
  before_save :upper_symbol
  class <<self
    def quote_tickets api
      api.multiple_single_quotes(all)
    end
  end

  private
  def upper_symbol
    symbol.upcase!
  end
end

class Watchlist < ApplicationRecord
  class <<self
    def quote_tickets api
      api.multiple_single_quotes(all)
    end
  end
end

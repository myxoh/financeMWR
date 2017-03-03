class LoadFinancialAssets
	class <<self
		def load
			@client  = FinancialAPI.new(sleep_time: 15) #Sleep time is set to 15 to avoid overloading server
			@tickets = Watchlist.quote_tickets(@client)
			@tickets.each do |ticket|
				ticket.notify_subscriptions
			end
		end
	end
end
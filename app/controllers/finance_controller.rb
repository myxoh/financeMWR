class FinanceController < ApplicationController
  def quote
  	external_api = FinancialAPI.new
  	results = external_api.quote(params[:value])
  	if results
  		render json:results
  	else
  		results = external_api.quote_lookup(params[:value])           #Lookup for value if this is not a precise symbol
  		render json: results
  	end
  end
end

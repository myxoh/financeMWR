class FinanceController < ApplicationController
  def quote
  	external_api = FinancialAPI.new
    results      = external_api.quote_lookup(params[:value])
  	results      = false unless results.any?           
    render json: results                      #If data is not false, return data as an array
  end
end

class FinancialAPI
  
  def initialize settings = {}
    settings =  {
        endpoint:       ENV['FINANICAL_API_ENDPOINT']       || 'http://dev.markitondemand.com/MODApis/Api/v2/', 
        parser_lambda:  ->(json_string){JSON.parse(json_string)}, #Use this lambda to make sure the output 
        method:         ENV['FINANICAL_API_METHOD']         || "get",
        lookup:         ENV['FINANICAL_API_LOOKUP']         || "Lookup/json",
        lookup_key:     ENV['FINANICAL_API_LOOKUP_KEY']     || "input",
        quote:          ENV['FINANICAL_API_QUOTE']          || "Quote/json",
        quote_key:      ENV['FINANICAL_QUOTE_KEY']          || "symbol",
        sleep_time:     ENV['FINANCIAL_SLEEP_TIME']         || 1
        #quote_market_key: nil #TODO: allow for future implementations to permit multiple market keys
      }.merge(settings)
      nil_params = settings.select{|data| data.blank?}
      raise "The setting #{nil_params.first[0].to_s} cannot be blank" unless nil_params.empty? #nil_params.first will return nil
    @settings = settings
  end

  def lookup value
    #Please note: This function expects an array of symbols with: {"Symbol"=>symbol,"Name"=>name,"Exchange"=>exchange}
    begin
      client = HTTPClient.new
      response = client.send(
        @settings[:method],                              #By default sends a get request.
        @settings[:endpoint]+@settings[:lookup],         #By default calls markitondeamnd/MODAps/Api/v2/Lookup
        {@settings[:lookup_key]=>value}                  #By default sends this payload: input=#{value}
      ).body                                             #Gets the response
      results = @settings[:parser_lambda].call(response) #By default calls JSON.parse on the response, allows for other parse methods
    rescue
      return [] #Returns an empty list if the HTTP connection failed.
    end
    results.map do |result| 
      Ticket.new(symbol: result['Symbol'], 
                 name: result['Name'], 
                 exchange: result['Exchange'])
    end
  end

  def quote value
    #Please note: This function expects: Status = SUCCESS if the ticker symobol exists 
    #Please note: This function expects: LastPrice to contain the price.
    begin
      client = HTTPClient.new
      response = client.send(
        @settings[:method],                              #By default sends a get request.
        @settings[:endpoint]+@settings[:quote],          #By default calls markitondeamnd/MODAps/Api/v2/Quote
        {@settings[:quote_key]=>value}                   #By default sends this payload: input=#{value}
      ).body                                             #Gets the response
      result = @settings[:parser_lambda].call(response)  #By default calls JSON.parse on the response, allows for other parse methods

    rescue
      return false #Returns false if the HTTP connection failed.
    end 
    if !result.try(:[],'Status').nil? and result['Status'] == 'SUCCESS'
      Ticket.new({symbol: result['Symbol'], price: result['LastPrice']}) 
    else
      false
    end
  end



  def multiple_single_quotes stocks #Quote all potential symbols (The default API only allows one quote at a time)
    stocks = stocks.map do |stock|
      value = if stock.is_a?(Ticket) then stock[:symbol] else stock.to_s end   #Allows for an array of symbols or an array of Tickets
      sleep @settings[:sleep_time]                     #Prevent multiple requests per second. For long lookups this might still fail on some requests    
      
      quote_result              = quote(value)
      if quote_result
        quote_result[:name]     = stock[:name]     if stock.is_a?(Ticket)
        quote_result[:exchange] = stock[:exchange] if stock.is_a?(Ticket)
      end
      quote_result #Return the full array including: Price, Symbol, Name and Exchange
    end
    stocks.select{|value| value}  #Returns only quotes, and not "Falses" that are generated on failed requests.
  end

  def quote_lookup value
      multiple_single_quotes(lookup(value))
  end


end

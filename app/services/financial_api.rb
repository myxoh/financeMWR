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
     results.map{ |result| {symbol: result['Symbol'], name: result['Name'], exchange: result['Exchange']} }
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
      {symbol: result['Symbol'], price: result['LastPrice']} 
    else
      false
    end
  end

  def multiple_single_quotes values #Quote all potential symbols (The default API only allows one quote at a time)
    values.map do |value|
      sleep 1                     #Prevent multiple requests per second. For long lookups this might still fail on some requests    
      value.quote
    end
    values.select{|value| value}  #Returns only quotes, and not "Falses" that are generated on failed requests.
    byebug
  end

  def quote_lookup value
      multiple_single_quotes(lookup(value).map!{|stock| (stock[:symbol])})
  end

end

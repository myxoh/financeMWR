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
    client = HTTPClient.new
    response = client.send(
      @settings[:method],                              #By default sends a get request.
      @settings[:endpoint]+@settings[:lookup],         #By default calls markitondeamnd/MODAps/Api/v2/Lookup
      {@settings[:lookup_key]=>value}                  #By default sends this payload: input=#{value}
    ).body                                             #Gets the response
    result = @settings[:parser_lambda].call(response)  #By default calls JSON.parse on the response, allows for other parse methods
    {symbol: result['Symbol'], name: result['Name'], exchange: result['Exchange']}
  end

  def quote value
    #Please note: This function expects: Status = SUCCESS if the ticker symobol exists 
    #Please note: This function expects: LastPrice to contain the price.
    client = HTTPClient.new
    response = client.send(
      @settings[:method],                              #By default sends a get request.
      @settings[:endpoint]+@settings[:quote],          #By default calls markitondeamnd/MODAps/Api/v2/Quote
      {@settings[:quote_key]=>value}                   #By default sends this payload: input=#{value}
    ).body                                             #Gets the response
    result = @settings[:parser_lambda].call(response)  #By default calls JSON.parse on the response, allows for other parse methods
    if result['Status'].exists? and results['Status'] == 'SUCCESS'
      {symbol: result['Symbol'], price: result['LastPrice']} 
    else
      false
    end
  end
end

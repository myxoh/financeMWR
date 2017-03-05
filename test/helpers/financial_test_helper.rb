module FinancialTestHelper
  def response_quote
    %Q[{"Status":"SUCCESS","Name":"Apple Inc","Symbol":"AAPL","LastPrice":139.78,"Change":0.819999999999993,"ChangePercent":0.590097869890611,"Timestamp":"Fri Mar 3 00:00:00 UTC-05:00 2017","MSDate":42797,"MarketCap":733361361200,"Volume":21571121,"ChangeYTD":115.82,"ChangePercentYTD":20.6872733552064,"High":139.83,"Low":138.59,"Open":138.78}]
  end

  def response_lookup
    %Q[[{"Symbol":"AAPL","Name":"Apple Inc","Exchange":"NASDAQ"},{"Symbol":"APLE","Name":"","Exchange":"NYSE"},{"Symbol":"APLE","Name":"Apple Hospitality REIT Inc","Exchange":"BATS Trading Inc"}]]
  end

  def alternative_response_quote
    %Q[{"Status":"SUCCESS","Name":"","Symbol":"APLE","LastPrice":19.06,"Change":-0.59,"ChangePercent":-3.00254452926209,"Timestamp":"Fri Mar 3 16:02:00 UTC-05:00 2017","MSDate":42797.6680555556,"MarketCap":4249217340,"Volume":1788633,"ChangeYTD":19.98,"ChangePercentYTD":-4.60460460460461,"High":19.496,"Low":18.97,"Open":19.4}]
  end

  def stub_quote(symbol, api = "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json", response = nil)
    response ||= response_quote
    stub_request(:get, "#{api}?symbol=#{symbol}").
    with(:headers => {'Accept'=>'*/*'}).
    to_return(:status => 200, :body =>response, :headers => {})
  end

  def stub_lookup(value, api = "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json")
    stub_request(:get, "#{api}?input=#{value}").
    with(:headers => {'Accept'=>'*/*'}).
    to_return(:status => 200, :body =>response_lookup, :headers => {})
  end

  def basic_api_setup
    @symbol = 'AAPL'
    stub_quote(@symbol)
    
    @value = 'APPLE'
    stub_lookup(@value)

    stub_quote('APLE', "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json", alternative_response_quote)
  end
end   
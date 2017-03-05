require 'test_helper'
require 'helpers/financial_test_helper'
include FinancialTestHelper

class FinanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    basic_api_setup
  end

  test "should get quote" do
    get finance_quote_url(value: "APPLE")
    assert_response :success
  end

end

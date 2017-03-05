require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def new_ticket
    Subscription.new(ticket: "GOOG", range_min: 20.0)
  end


  test "Only received unchecked" do
    assert Subscription.unmatched.count == 1
  end

  test "Can create" do
    subscription = new_ticket
    assert subscription.save
  end

  test "Required params" do
    subscription = Subscription.new(ticket: "gg")
    assert_not subscription.save      #Should require range_min
    subscription.range_min = 20.0
    subscription.save
    subscription.reload
    assert subscription.ticket == "GG" #Should capitalize tickets
  end

  test "Creates a Watchlist" do
    subscription = new_ticket
    subscription.save
    assert Watchlist.find_by(symbol: 'GOOG') #Watchlist was created
  end


  test "name not nil" do
    assert_not subscriptions(:checked).name.nil?
  end
end

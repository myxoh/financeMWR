def Ticket
  attr_accesor :price, :name, :symbol, :exchange
  include Notifier

  def load_subscribers
    Subscription.where(symbol: @symbol)
  end

  def notify_subscriptions
    load_subscribiers.each do |subscription|
      notify(subscription.check(@price))
    end
  end
end

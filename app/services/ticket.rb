class Ticket
  PUBLIC_ATTRIBUTES = [:price, :name, :symbol, :exchange] #Whitelisted attributes
  attr_accessor *PUBLIC_ATTRIBUTES
  include Notifier
  include ActAsHash

  def initialize(hash_of_values = {})
    @price    = hash_of_values.try(:[], :price)
    @symbol   = hash_of_values.try(:[], :symbol)
    @exchange = hash_of_values.try(:[], :exchange)
    @name     = hash_of_values.try(:[], :name)
    @public_attributes = PUBLIC_ATTRIBUTES
  end

  def load_subscribers
    Subscription.unmatched.where(ticket: @symbol)
  end

  def notify_subscriptions
    load_subscribers.each do |subscription|
      event = subscription.check(@price)
      notify(event) if event
    end
  end

end

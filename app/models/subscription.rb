class Subscription < ApplicationRecord
  has_one :notification
  def check(stock)
    #TODO check the ticket
    event = Event.new(self)
    event.description = "Your stock has reached the desired level!"
    return event
  end

  def name
  end
end

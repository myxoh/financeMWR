class Subscription < ApplicationRecord
  has_one :notification
  before_save :upper_ticket
  after_create :add_to_watchlist
  validates :range_min, presence: true
  scope :unmatched, ->{where(last_checked: nil)}
  def check(stock)
    #TODO (future versions) allow for different price checks.
    if stock>range_min
      event = Event.new(self)
      event.description = "Your stock has reached the desired level!"
      self.update(last_checked: Time.now)
      return event
    end
    false
  end

  def name
    "Checking whether #{ticket.to_s}'s price is > #{range_min.to_s}"
  end

  private
  def add_to_watchlist
    Watchlist.find_or_create_by(symbol: ticket.strip.upcase)
  end

  def upper_ticket
    ticket.upcase!
  end
end

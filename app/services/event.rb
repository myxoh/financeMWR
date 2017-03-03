class Event
  attr_accessor :generator, :description
  def initialize father
    @generator = father
  end
end
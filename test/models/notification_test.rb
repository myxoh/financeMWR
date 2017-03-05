require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Only get unread notifications" do
    assert Notification.all.count == 1
  end

end

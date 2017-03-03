module Notifier
  def notify           event
    send_email settings(send_email)        if settings[:send_email]
    send_notification settings(send_email) if settings[:send_notification]
  end

  private
  def send_email       event
    #Not implemented
  end

  def send_notification event
    Notification.create(
      read: false,
      subscription: event.generator,
      description:  event.description
      )
  end

  def settings
    #This is the default notification settings:
    #Send e-mail is set to false. Send e-mail is not implemented
    #Send notification is turned on by default.
    {
      send_email:        ENV['NOTIFIER_SEND_EMAIL']       || false,
      receiving_email:   ENV['NOTIFIER_RECEIVING_EMAIL']  || "default@test.com",
      send_notification: ENV['NOTIFIER_SEND_NOTIFICAION'] || true
    }
  end
end
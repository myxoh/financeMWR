class Notification < ApplicationRecord
  belongs_to :subscription
  default_scope {where.not(read: true)}

  def message
    {generated_by: subscription.ticket, watching: "Price \> #{subscription.range_min}", description: description}
  end
end

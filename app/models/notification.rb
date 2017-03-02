class Notification < ApplicationRecord
  belongs_to :subscription
  default_scope {where.not(read: true)}
end

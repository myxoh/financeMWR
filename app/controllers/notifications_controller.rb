class NotificationsController < ApplicationController
  after_action :clear, only: [:index]
  def index
  	@notifications = Notification.all.order(:created_at)
  	render json: @notifications
  end

  private 
  def clear
    @notifications.update_all(read: true)
  end
end

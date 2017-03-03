class NotificationsController < ApplicationController
  after_action :clear, only: [:index]
  def index
  	@notifications = Notification.all.joins(:subscription).order(:created_at)
  	render json: @notifications.map{|notification| notification.message }
  end

  private 
  def clear
    @notifications.update_all(read: true)
  end
end

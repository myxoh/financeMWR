class SubscribeController < ApplicationController
  def create
    Subscription.create!(ticket: params[:symbol], range_min: params[:price])
    render text: "SUCCESS"
  end
end

class landingPagesController < ApplicationController
  def index
    @cars = Car.order(created_at: :desc).limit(6)
  end
end

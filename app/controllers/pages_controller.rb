class PagesController < ApplicationController
  def terms
  end
   skip_before_action :authenticate_user!, only: [:landing]
  def landing
    @featured_cars = Car.order(created_at: :desc).limit(6)
  end
end

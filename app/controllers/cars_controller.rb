class CarsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show search]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_car, only: %i[show edit update destroy]
  before_action :authorize_car_owner!, only: %i[edit update destroy]

  def index
    @cars = Car.where(status: "published")

    if params[:query].present?
      @cars = @cars.where("make ILIKE ? OR model ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    if params[:category].present?
      @cars = @cars.where(category: params[:category])
    end

    if params[:price_range].present?
      @cars =
        case params[:price_range]
        when "low"  then @cars.where("price < ?", 5000)
        when "mid"  then @cars.where("price BETWEEN ? AND ?", 5000, 10000)
        when "high" then @cars.where("price > ?", 10000)
        when "sold" then @cars.where(status: "sold")
        else @cars
        end
    end

    @cars = @cars.order("RANDOM()")
    @featured_cars = Car.where(status: "published").order("RANDOM()").limit(10)
  end

  def search
    @cars = Car.where(status: "published")
    @cars = @cars.by_destination(params[:destination]) if params[:destination].present?

    if params[:start_time].present? && params[:end_time].present?
      @cars = @cars.available_between(params[:start_time], params[:end_time])
    end

    @cars = @cars.order("RANDOM()")
    @featured_cars = Car.where(status: "published").order("RANDOM()").limit(10)

    render :index
  end

  def show
    if @car.status == "draft" && @car.owner != current_user
      redirect_to cars_path, alert: "This car is not available for public viewing." and return
    end

    if params[:start_time].present? && params[:end_time].present?
      unless @car.available?(params[:start_time], params[:end_time])
        flash.now[:alert] = "This car is not available from #{params[:start_time]} to #{params[:end_time]}."
      end
    end
  end

  def new
    @car = Car.new
  end

  def edit; end

  def create
    @car = current_user.cars.build(car_params.except(:images))
    @car.status = params[:draft] ? "draft" : "published"

    attach_images(@car, params[:car][:images]) if params[:car][:images].present?

    if @car.save
      message = @car.status == "draft" ? "Car saved as draft." : "Car published successfully."
      redirect_to @car, notice: message
    else
      flash.now[:alert] = "Image upload may have failed. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @car.status = params[:draft] ? "draft" : "published"

    attach_images(@car, params[:car][:images]) if params[:car][:images].present?

    if @car.update(car_params.except(:images))
      redirect_to @car, notice: "Car updated successfully."
    else
      flash.now[:alert] = "Update failed. Please try again."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy!
    redirect_to cars_path, notice: "Car was successfully deleted."
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def authorize_car_owner!
    redirect_to cars_path, alert: "Not authorized to modify this car." unless @car.owner == current_user
  end

  def car_params
    params.require(:car).permit(
      :make,
      :model,
      :year,
      :price,
      :description,
      :listing_type,
      :deposit_amount,
      :pickup_address,
      :latitude,
      :longitude,
      :category,
      :transmission_type,
      :fuel_type,
      :insurance_status,
      :seats,
      :status,
      images: []
    )
  end

  def attach_images(car, images)
    uploader = SupabaseStorageService.new
    images.each_with_index do |image, idx|
      next unless image.respond_to?(:original_filename)

      Rails.logger.info("📦 Processing image: #{image.original_filename}")
      public_url = uploader.upload(image)
      Rails.logger.info("🌐 Supabase returned URL: #{public_url}")
      car.car_images.build(image_url: public_url, cover: idx.zero? && car.car_images.empty?) if public_url.present?
    end
  end
end

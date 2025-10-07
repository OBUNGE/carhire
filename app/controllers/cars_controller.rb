class CarsController < ApplicationController
  # Guests can browse and view published cars
  skip_before_action :authenticate_user!, only: %i[index show search]

  # Must be logged in to create, edit, update, or delete a car
  before_action :authenticate_user!, only: %i[new create edit update destroy purge_image]
  before_action :set_car, only: %i[show edit update destroy purge_image]
  before_action :authorize_car_owner!, only: %i[edit update destroy purge_image]

  def index
    # Only show published cars to guests
    @cars = Car.where(status: "published")

    # Search by make or model
    if params[:query].present?
      @cars = @cars.where("make ILIKE ? OR model ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    # Filter by category
    if params[:category].present?
      @cars = @cars.where(category: params[:category])
    end

    # Filter by price range
    if params[:price_range].present?
      case params[:price_range]
      when "low"
        @cars = @cars.where("price < ?", 5000)
      when "mid"
        @cars = @cars.where("price >= ? AND price <= ?", 5000, 10000)
      when "high"
        @cars = @cars.where("price > ?", 10000)
      when "sold"
        @cars = @cars.where(status: "sold")
      end
    end

    # Randomise order for grid
    @cars = @cars.order("RANDOM()")

    # Featured cars for carousel
    @featured_cars = Car.where(status: "published").order("RANDOM()").limit(10)
  end

  def search
    @cars = Car.where(status: "published")

    # Filter by destination (pickup_address)
    if params[:destination].present?
      @cars = @cars.by_destination(params[:destination])
    end

    # Filter by availability
    if params[:start_time].present? && params[:end_time].present?
      @cars = @cars.available_between(params[:start_time], params[:end_time])
    end

    # Randomise order for results
    @cars = @cars.order("RANDOM()")

    # Featured cars for carousel
    @featured_cars = Car.where(status: "published").order("RANDOM()").limit(10)

    render :index
  end

  def show
    if @car.status == "draft" && @car.owner != current_user
      redirect_to cars_path, alert: "This car is not available for public viewing."
      return
    end

    # Display Supabase image URLs
    @image_urls = @car.image_urls || []

    # Availability check if dates are passed in
    if params[:start_time].present? && params[:end_time].present?
      unless @car.available?(params[:start_time], params[:end_time])
        flash.now[:alert] = "This car is not available from #{params[:start_time]} to #{params[:end_time]}."
      end
    end
  end

  def new
    @car = Car.new
  end

  def edit
  end

  def create
    @car = Car.new(car_params.except(:images))
    @car.owner = current_user
    @car.status = params[:draft] ? "draft" : "published"

    if params[:car][:images].present?
      @car.image_urls = []
      storage = SupabaseStorageService.new

      params[:car][:images].each do |file|
        url = storage.upload(file)
        @car.image_urls << url if url
      end
    end

    if @car.save
      message = @car.status == "draft" ? "Car saved as draft." : "Car published successfully."
      redirect_to @car, notice: message
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @car.status = params[:draft] ? "draft" : "published"

    if params[:car][:images].present?
      storage = SupabaseStorageService.new
      params[:car][:images].each do |file|
        url = storage.upload(file)
        @car.image_urls << url if url
      end
    end

    if @car.update(car_params.except(:images))
      redirect_to @car, notice: "Car updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy!
    redirect_to cars_path, notice: "Car was successfully deleted."
  end

  def purge_image
    if params[:image_url].present?
      @car.image_urls.delete(params[:image_url])
      @car.save
      redirect_to edit_car_path(@car), notice: "Image deleted successfully."
    else
      redirect_to edit_car_path(@car), alert: "No image specified."
    end
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def authorize_car_owner!
    unless @car.owner == current_user
      redirect_to cars_path, alert: "Not authorized to modify this car."
    end
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
end

class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car, only: [:new, :create]


  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = @car.purchases.build(purchase_params)
    @purchase.user = current_user

    if @purchase.save
      redirect_to car_path(@car), notice: "Purchase request submitted!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def approve
  purchase = Purchase.find(params[:id])
  if purchase.pending?
    purchase.approved!
    redirect_to owner_dashboard_path, notice: "Purchase approved."
  else
    redirect_to owner_dashboard_path, alert: "Only pending purchases can be approved."
  end
end

def reject
  purchase = Purchase.find(params[:id])
  if purchase.pending?
    purchase.rejected!
    redirect_to owner_dashboard_path, alert: "Purchase rejected."
  else
    redirect_to owner_dashboard_path, alert: "Only pending purchases can be rejected."
  end
end
# app/controllers/purchases_controller.rb
def cancel
  @purchase = Purchase.find(params[:id])

  if @purchase.pending?
    @purchase.update(status: :cancelled)
    flash[:notice] = "Your request has been cancelled."
  else
    flash[:alert] = "Only pending requests can be cancelled."
  end

  redirect_to renter_dashboard_path
end
# app/controllers/purchases_controller.rb
def destroy
  @purchase = Purchase.find(params[:id])

  if @purchase.rejected? || @purchase.cancelled?
    @purchase.destroy
    flash[:notice] = "Purchase request deleted."
  else
    flash[:alert] = "Only rejected or cancelled requests can be deleted."
  end

  redirect_to renter_dashboard_path
end



  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def purchase_params
   params.require(:purchase).permit(:message, :contact_info)

  end
end

class User::Tools::CouponsController < User::BaseController

  def index
    @coupons = Coupon.all
    @coupon = Coupon.new
  end

  def create
    if Coupon.find_by_code  params[:coupon][:code]
      render json: {}, status: :not_found and return
    end
    @coupon = Coupon.new(coupon_params)
    if params[:coupon][:discount_type] == 'cents' && params[:coupon][:discount]
      @coupon.discount_money = params[:coupon][:discount]
    end
    if @coupon.is_valid? && @coupon.save
      respond_to do |format|
        format.js {}
      end
    else
      render json: {errors: @coupon.errors}, status: :not_found
    end
  end

  def destroy
    Coupon.find(params[:id]).delete
    @id = params[:id]
    respond_to do |format|
      format.js {}
    end
  end

  def update
  end

  def sync
  end

  def coupon_params
    params.require(:coupon).permit(:discount_type, :code, :discount, :product_id,
     :expire, :available)
  end
end
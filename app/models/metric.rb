class Metric
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include API

  def initialize(user_id)
    @user_id = user_id
  end

  def sales(product_id = nil)
    if product_id
      API.api.get("metrics/products/#{product_id}/sales").body
    else
      API.api.get("metrics/products/sales/user/#{@user_id}").body
   end
 end




end
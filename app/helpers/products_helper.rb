module ProductsHelper
  def error_class(product, field)
    if product.errors[field].present?
      'has-error'
    end
  end
end

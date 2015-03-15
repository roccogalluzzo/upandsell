module CheckoutProduct extend ActiveSupport::Concern

  def register_visit(product)
    ua = AgentOrange::UserAgent.new(request.env['HTTP_USER_AGENT'])

    if !ua.is_bot? && !session[:user][:visits].include?(product.id) && session[:user][:last_visit] >  30.minutes.ago
      Metric::Product.new(product).record_visit
      session[:user][:visits] << product.id
      session[:user][:last_visit] = Time.now
    end
  end
end

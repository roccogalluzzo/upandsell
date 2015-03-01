class Admin::InvoicesController < Admin::BaseController

  def index
    @invoices = SubscriptionInvoice.finalized.page(params[:page]).per(8)
  end

end

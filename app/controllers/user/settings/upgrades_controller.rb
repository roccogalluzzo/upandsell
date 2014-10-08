class User::Settings::UpgradesController < User::BaseController

  def edit
  end

  def update
    response = Gateways::Paymill.subscribe(params[:token])
    if response.success?
     current_user.update_attribute(account: 'pro')
     if current_user.referer_id
      Referral.new(referer_id: current_user.referer_id, user_id: current_user.id,
        amount: 1500, status: 'pending')
    end
  end
  render json: {response: response}
end
end
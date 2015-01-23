module Features
  module StripeHelpers

    def self.setup_stripe
      Stripe::Plan.create(
        amount: 2499,
        interval: 'month',
        name: 'Monthly App Plan',
        currency: 'eur',
        id: 'MONTHLY_PLAN')
      Stripe::Plan.create(
        amount: 24999,
        interval: 'month',
        name: 'Yearly App Plan',
        currency: 'eur',
        id: 'YEARLY_PLAN')
    end

    def stub_stripe_token_request!(success: true)
      if success
        stub_success_token
      else
        stub_failed_token
      end
    end

    private

    def stub_success_token
      proxy.stub('https://api.stripe.com:443/v1/tokens').
      and_return(Proc.new { |params|
        { :code => 200, :text => "#{params['callback'][0]}({
          'id': 'tok_2Z0Jh5UWnSrAeL',
          'livemode': false,
          'created': 1379062337,
          'used': false,
          'object': 'token',
          'type': 'card'
          },
          200)" } })
    end

    def stub_failed_token
      proxy.stub('https://api.stripe.com:443/v1/tokens').
      and_return(Proc.new { |params|
        { :code => 200, :text => "#{params['callback'][0]}({
          'error': {
            'message': 'Your card number is incorrect.',
            'type': 'card_error',
            'param': 'number',
            'code': 'incorrect_number'
          }
        }
        , 402)" } })
    end
  end
end
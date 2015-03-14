require 'rails_helper'

describe PaymentService do
  let(:service) { PaymentService.new }
  let(:payer_paypal) { {
    return_url: 'http://ciao.com',
    cancel_url: 'http://ciao.com'} }
    let(:card) {{
      number: "4242424242424242",
      exp_month: 2,
      exp_year: 2016,
      cvc: "314"
      }}
      before do
        @product = create(:product)
        @user = @product.user
      end
      context 'with Stripe Gateway' do
        before do
          @user.credit_card_token = 'sk_test_6uBq0SMfkKrgiBZ4ZWPVSGgN'
          @user.save
        end
        describe '#pay' do
         context 'with a fake token' do
          it 'return false' do
            VCR.use_cassette("service_gateway_stripe_pay_fake") do
            order = PaymentService.new('stripe')
            .pay(@product, {email: @user.email, token: 'fake_token', new_price: 5000})
            expect(order).to eq false
          end
        end
      end
      context 'with a discount' do
        it 'return completed order' do
         VCR.use_cassette("service_gateway_stripe_pay_discount") do
           Stripe.api_key = @user.credit_card_token
           stripe_token  = Stripe::Token.create(card: card).id
           order = PaymentService.new('stripe')
           .pay(@product, {email: @user.email, token: stripe_token, new_price: 5000})
           expect(order.amount).to eq 5000
           expect(order.amount_currency).to eq @product.price_currency
           expect(order.status).to eq 'completed'
           expect(order.payment_details[:card]).to eq 'visa'
           expect(order.gateway).to eq 'stripe'
         end
       end
     end
     it 'return completed order' do
      VCR.use_cassette("service_gateway_stripe_pay") do
       Stripe.api_key = @user.credit_card_token
       stripe_token  = Stripe::Token.create(card: card).id
       order = PaymentService.new('stripe')
       .pay(@product, {email: @user.email, token: stripe_token})
       expect(order.email).to eq @user.email
       expect(order.gateway_token).to_not eq nil
       expect(order.amount).to eq @product.price
       expect(order.amount_currency).to eq @product.price_currency
       expect(order.status).to eq 'completed'
       expect(order.payment_details[:card]).to eq 'visa'
       expect(order.gateway).to eq 'stripe'
       expect(order.gateway_token).to_not eq nil
       expect(order.coupon_id).to eq nil
     end
   end
 end
 describe '#refund' do
  it 'returns true' do
   VCR.use_cassette("service_gateway_stripe_refund") do
     response = PaymentService.new('stripe')
     .refund('ch_15fdq5AQkfalJzyKedHWfxKU', @product.price_cents, @user.id)
     expect(response).to eq true
   end
 end
 it 'returns false' do
   VCR.use_cassette("service_gateway_stripe_refund_already_refunded") do
     response = PaymentService.new('stripe')
     .refund('ch_15fdq5AQkfalJzyKedHWfxKU', @product.price_cents, @user.id)
     expect(response).to eq false
   end
 end
end
end

context 'with Paymill Gateway' do
  before do
    @user.credit_card_token = 'a304f4f8844b61d80a399f8dd3ec561f'
    @user.save
  end
  describe '#pay' do
   context 'with a fake token' do
    it 'return false' do
     VCR.use_cassette("service_gateway_paymill_pay_fake") do
      order = PaymentService.new('paymill')
      .pay(@product, {email: @user.email, token: 'fake_token', new_price: 5000})
      expect(order).to eq false
    end
  end
end
context 'with a discount' do
  it 'return completed order' do
   VCR.use_cassette("service_gateway_paymill_pay_discount") do
     order = PaymentService.new('paymill')
     .pay(@product, {email: @user.email, token: 'tok_053f96c375bd24bb00a2', new_price: 5000})
     expect(order.amount).to eq 5000
     expect(order.amount_currency).to eq @product.price_currency
     expect(order.status).to eq 'completed'
     expect(order.payment_details[:card]).to eq 'visa'
     expect(order.gateway).to eq 'paymill'
   end
 end
end
it 'return completed order' do
  VCR.use_cassette("service_gateway_paymill_pay") do
    order = PaymentService.new('paymill')
    .pay(@product, {email: @user.email, token: 'tok_d0c639a9047b742192c6'})
    expect(order.email).to eq @user.email
    expect(order.gateway_token).to_not eq nil
    expect(order.amount).to eq @product.price
    expect(order.amount_currency).to eq @product.price_currency
    expect(order.status).to eq 'completed'
    expect(order.payment_details[:card]).to eq 'visa'
    expect(order.gateway).to eq 'paymill'
    expect(order.gateway_token).to_not eq nil
    expect(order.coupon_id).to eq nil
  end
end
end
describe '#refund' do
  it 'returns true' do
   VCR.use_cassette("service_gateway_paymill_refund") do
     response = PaymentService.new('paymill')
     .refund('tran_2660df8c4398b463c5ffa8b78f88', @product.price_cents, @user.id)
     expect(response).to eq true
   end
 end
 it 'returns false' do
   VCR.use_cassette("service_gateway_stripe_paymill_already_refunded") do
     response = PaymentService.new('paymill')
     .refund('tran_2660df8c4398b463c5ffa8b78f88', @product.price_cents, @user.id)
     expect(response).to eq false
   end
 end
end
end

context 'with BrainTree Gateway' do
  before do
    @user.credit_card_token = '8603e05feca8a79c5af5976e9cad4758'
    @user.credit_card_bt_merchant_id = '8kcrqvtj3vxqx9fr'
    @user.credit_card_public_token = 'xmxtnt4f2qkdbbtw'

    @user.save
  end
  describe '#pay' do
    context 'with a discount' do
      it 'return completed order' do
       VCR.use_cassette("service_gateway_braintree_pay_discount") do
         order = PaymentService.new('braintree')
         .pay(@product, {email: @user.email, token: '640de287-61f1-4232-a164-193babdbfc45', new_price: 5000})
         expect(order.amount).to eq 5000
         expect(order.amount_currency).to eq @product.price_currency
         expect(order.status).to eq 'completed'
         expect(order.payment_details[:card]).to eq 'visa'
         expect(order.gateway).to eq 'braintree'
       end
     end
   end
   context 'with a fake token' do
    it 'return false' do
     VCR.use_cassette("service_gateway_braintree_pay_fake") do
       order = PaymentService.new('braintree')
       .pay(@product, {email: @user.email, token: 'fake_token', new_price: 5000})
       expect(order).to eq false
     end
   end
 end
 context 'with a fake api key' do
  it 'return false' do
    @user.credit_card_token = 'fake'
    @user.save
    VCR.use_cassette("service_gateway_braintree_pay_fake_token") do
     order = PaymentService.new('braintree')
     .pay(@product, {email: @user.email, token: 'fake_token', new_price: 5000})
     expect(order).to eq false
   end
 end
end
context 'with another currency product' do
  it 'return false' do
    VCR.use_cassette("service_gateway_braintree_pay_no_currency", record: :new_episodes) do
      @product.price_currency = 'eur'
      @product.save
      order = PaymentService.new('braintree')
      .pay(@product, {email: @user.email, token: '9136cc74-8260-45f4-95c3-a0aa608456b1', new_price: 5000})
      expect(order).to eq false
    end
  end
end
it 'return completed order' do
  VCR.use_cassette("service_gateway_braintree_pay") do
    order = PaymentService.new('braintree')
    .pay(@product, {email: @user.email, token: '61070cd0-d13e-49b2-ba70-5d8488edb69f'})
    expect(order.email).to eq @user.email
    expect(order.gateway_token).to_not eq nil
    expect(order.amount).to eq @product.price
    expect(order.amount_currency).to eq @product.price_currency
    expect(order.status).to eq 'completed'
    expect(order.payment_details[:card]).to eq 'visa'
    expect(order.gateway).to eq 'braintree'
    expect(order.gateway_token).to_not eq nil
    expect(order.coupon_id).to eq nil
  end
end
end
describe '#refund' do
  it 'returns true' do
   VCR.use_cassette("service_gateway_braintree_refund") do
     response = PaymentService.new('braintree')
     .refund('9rg48d', @product.price_cents, @user.id)
     expect(response).to eq true
   end
 end
 it 'returns false' do
   VCR.use_cassette("service_gateway_stripe_braintree_already_refunded") do
     response = PaymentService.new('braintree')
     .refund('9rg48d', @product.price_cents, @user.id)
     expect(response).to eq false
   end
 end
end
end
end

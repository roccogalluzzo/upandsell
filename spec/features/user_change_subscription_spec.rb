require 'rails_helper'

feature "Change Subscriptions settings", js: true, stripe: true do

  context "when update Billing form" do
    let(:stripe_helper) { StripeMock.create_test_helper }

    background do
      @user = SessionHelpers.create_logged_in_active_user(stripe_helper.generate_card_token)
      visit  edit_user_settings_billing_path
    end

    context "with a new credit card" do

      scenario "should show new last 4 chars" do
        click_button('Edit Billing Info')
        fill_credit_card
        token = StripeMock.generate_card_token(last4: '4242', exp_year: 2020)
        stub_success_token(token)
        click_button('Save')
        wait_for_ajax
        expect(page).to have_content '4242'
      end

    end

    context "with new billing info" do

      scenario "should show success message" do
        click_button('Edit Billing Info')
        fill_in "user_legal_name", with: 'Rocco Galluzzo'
        click_button('Save')
        wait_for_ajax
        sleep 2
        expect(page).to have_content 'Billing Info Updated'
      end

    end

    context "with a new plan" do

      scenario "should show new active plan" do
        click_button('Edit Billing Info')
        find('.year-plan').trigger('click')
        click_button('Save')
        wait_for_ajax
        expect(page).to have_content 'YEARLY PLAN'
      end

    end

    context "unsubscribe from the plan" do

      scenario "should unsubscribe from the plan" do
        click_link('Cancel Subscription')
        wait_for_ajax
        expect(page).to have_content "You currently don't have an active subscription, so you can't create or sell products."
      end

    end
  end
end

def stub_success_token(token)
  proxy.stub('https://api.stripe.com:443/v1/tokens').
  and_return(Proc.new { |params|
    { :code => 200, :text => "#{params['callback'][0]}({
      'id': '#{token}',
      'livemode': false,
      'created': 1379062337,
      'used': false,
      'object': 'token',
      'type': 'card'
      },
      200)" } })
end



def fill_credit_card
  fill_in "cc_number", with: '4242424242424242'
  fill_in "cc_expire", with: '10/20'
  fill_in "cc_cvc", with: '123'
end

def select1(id, options)
  page.execute_script %Q{
    i = $('#s2id_#{id} .select2-offscreen');
    i.trigger('keydown').val('#{options[:query]}').trigger('keyup');
  }

  within(".select2-drop-active") do
   find(".select2-result-label", :text => options[:choose]).click
 end
end
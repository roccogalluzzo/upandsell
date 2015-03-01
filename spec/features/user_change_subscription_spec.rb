require 'rails_helper'

feature "Change Subscriptions settings", js: true, stripe: true do
  context "when update Billing form" do
    background do
      VCR.use_cassette("feature_billing_create_customer", :record => :new_episodes) do
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2016,
            :cvc => "314"
            },
            ).id
        @user = SessionHelpers.create_logged_in_active_user(token)
      end
      visit  edit_user_settings_billing_path
    end

    context "with a new credit card" do
      scenario "should show new last 4 chars" do
        VCR.use_cassette("feature_billing_change_cc", :record => :new_episodes) do
          click_button('Edit Billing Info')
          fill_credit_card
          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 2,
              :exp_year => 2016,
              :cvc => "314"
              },
              ).id
          stub_success_token(token)
          click_button('Save')
          wait_for_ajax
          sleep 2
          expect(page).to have_content '4242'
        end
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
        VCR.use_cassette("feature_billing_change_plan", :record => :new_episodes) do
          click_button('Edit Billing Info')
          find('.year-plan').trigger('click')
          click_button('Save')
          wait_for_ajax
          expect(page).to have_content 'YEARLY PLAN'
        end
      end

    end

    context "unsubscribe from the plan" do
      scenario "should unsubscribe from the plan" do
        VCR.use_cassette("feature_billing_unsubscribe", :record => :new_episodes) do
          click_link('Cancel Subscription')
          wait_for_ajax
          sleep 2
          expect(page).to have_content "The subscription expires on"
        end
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
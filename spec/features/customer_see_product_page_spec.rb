require 'rails_helper'

feature "Customer see product page", js: true do
  before do
    @user = create(:cc_user)
    @product = create(:product, user: @user)
  end
  context "visiting product page when user doesn't have an" do
    scenario 'active subscription' do
      @user.subscription_end = 3.days.ago
      @user.save
      visit product_slug_path(@product.slug)
      expect(page).to have_content @product.name
      expect(page).to have_content "This product is no longer for sale"
    end

    scenario 'active payment' do
      @user.credit_card_gateway = nil
      @user.credit_card_token = nil
      @user.credit_card_public_token = nil
      @user.subscription_end = 3.days.from_now
      @user.save
      visit product_slug_path(@product.slug)
      expect(page).to have_content @product.name
      expect(page).to have_content "This product is no longer for sale"
    end
  end
  context "visiting product page when user have an" do
    scenario 'active subscription and cc gateway' do
      visit product_slug_path(@product.slug)
      expect(page).to have_content @product.name
      expect(page).to have_content "BUY NOW"
    end

    scenario 'active subscription and paypal' do
      @user.credit_card_gateway = nil
      @user.credit_card_token = nil
      @user.credit_card_public_token = nil
      @user.paypal = true
      @user.paypal_email = 'rocco@galluzzo.me'
      @user.paypal_token = 'token'
      @user.paypal_token_secret = 'public_token'
      @user.subscription_end = 3.days.from_now
      @user.save
      visit product_slug_path(@product.slug)
      expect(page).to have_content @product.name
      expect(page).to have_content "BUY NOW"
    end
  end
end


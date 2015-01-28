require "rails_helper"

describe User do
  let(:user) {create(:user)}
  let(:cc_user) {build(:cc_user)}
  let(:paypal_user) {build(:paypal_user)}
  let(:admin) {build(:user, email: 'rocco@galluzzo.me')}

  describe 'welcome_email' do
    context 'when user create new account' do
      it 'should send the welcome email and email confirmation' do
          Sidekiq::Worker.clear_all
        expect {UserMailer.delay.welcome(user.id)}
        .to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(2)
      end
    end
  end

  describe '#admin?' do

    context 'when the user is an admin' do
      it { expect(admin.admin?).to eq(true) }
    end
    context 'when the user is not an admin' do
      it { expect(user.admin?).to eq(false) }
    end
  end

  describe '#credit_card_active?' do

    context 'when the user have credit card credentials' do
      it { expect(cc_user.credit_card_active?).to eq(true) }
    end
    context 'when the user dont have credit card credentials' do
      it { expect(user.credit_card_active?).to eq(false) }
    end
  end

  describe '#paypal_active?' do

    context 'when the user have paypal credentials' do
      it { expect(paypal_user.paypal_active?).to eq(true) }
    end
    context 'when the user dont have paypal credentials' do
      it { expect(user.paypal_active?).to eq(false) }
    end
  end

end

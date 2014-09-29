class User < ActiveRecord::Base
  include Unsubscribable

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable, :async
  serialize :settings
  serialize :credit_card_info
  serialize :paypal_info
  serialize :custom_email_message, Hash
  serialize :createsend_token

  validates_presence_of :name, :email
  validates_confirmation_of :password
  validates :ga_code,  allow_blank: true,
  length: { is: 13 }, format: {with:/[Uu][Aa]-\d{8}-\d/,
  message: "Google Analitycs Code Not Valid." }

  has_many :orders
  has_many :products
  has_many :referrals
  has_many :referrals_payments

  mount_uploader :avatar, AvatarUploader


  before_create do
    self.currency = Upandsell::Application.config.default_currency.upcase
  end

  after_create :send_welcome_email

  def self.serialize_payment_info(type, *args)
    args.each do |method_name|
      eval "
      def #{type}_#{method_name}
        (self.#{type}_info || {})[:#{method_name}]
      end
      def #{type}_#{method_name}=(value)
        self.#{type}_info ||= {}
        self.#{type}_info[:#{method_name}] = value
      end
      "
    end
  end

  serialize_payment_info :paypal, :email, :token, :token_secret
  serialize_payment_info :credit_card, :token, :public_token, :response



  def admin?
    Rails.application.secrets.admins.include?(email)
  end

  def send_welcome_email
    UserMailer.delay.welcome_email(self)
  end

def connect_credit_card(data)
  self.credit_card = true
  self.credit_card_token = data.credentials.token
  self.credit_card_public_token = data.extra.raw_info.public_key
  self.credit_card_response = data.extra.raw_info
  self.save
end

def connect_paypal(email, token, token_secret)
  self.paypal = true
  self.paypal_email = email
  self.paypal_token = token
  self.paypal_token_secret = token_secret
  self.save
end

end
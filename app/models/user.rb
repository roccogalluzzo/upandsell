class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable

  has_many :products
  has_many :orders

  validates_confirmation_of :password
  serialize :settings
  serialize :credit_card_info
  serialize :paypal_info

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

  after_create :send_welcome_email

  def admin?
   true if self.id == 1
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end

  def update_account(params)
    self.update_attributes(params)
  end

  def add_credit_card(data)
    self.credit_card = true
    self.credit_card_token = data['access_token']
    self.credit_card_public_token = data['public_key']
    self.credit_card_response = data
    self.save
  end

  def add_paypal_refund(email, token, token_secret)
    self.paypal = true
    self.paypal_email = email
    self.paypal_token = token
    self.paypal_token_secret = token_secret
    self.save
  end
end
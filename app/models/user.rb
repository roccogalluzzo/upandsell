class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable

  has_many :products
  has_many :orders

before_create { self.settings ={currency: 'USD'}}
  validates_confirmation_of :password
  serialize :settings
  def self.serialized_attr_accessor(*args)
    args.each do |method_name|
      eval "
        def #{method_name}
          (self.settings || {})[:#{method_name}]
        end
        def #{method_name}=(value)
          self.settings ||= {}
          self.settings[:#{method_name}] = value
        end
      "
    end
  end

  serialized_attr_accessor :paypal_status, :paypal_email,
   :credit_card_token, :credit_card_status, :currency, :credit_card_public_token

  after_create :send_welcome_email



    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end
  def update_account(params)
    self.update_attributes(params)
  end

  def add_credit_card(data)
    self.credit_card_token = data['access_token']
    self.credit_card_public_token = data['public_key']
    self.credit_card_status = true
    self.settings[:gateway_info] = data
    self.save
  end
   def add_paypal_refund(token, token_secret)
    self.paypal_status = true
    self.settings[:paypal_tokens] = {token: token, token_secret: token_secret}
    self.save
  end
end
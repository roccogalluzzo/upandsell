class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable

  has_many :products
  has_many :orders

before_create { self.settings[:currency] = 'USD'}
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
   :credit_card_token, :credit_card_status, :currency

  def update_account(params)
    self.update_attributes(params)
  end

  def add_credit_card(data)
    self.credit_card_token = data['access_token']
    self.credit_card_status = true
    self.settings[:gateway_info] = data
    self.save
  end
end
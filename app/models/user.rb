class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable

  has_many :products
  has_many :orders

  validates_confirmation_of :password
  serialize :gateway_info
  def update_account(params)
    self.update_attributes(params)
  end

  def add_credit_card(data)
    self.credit_card_token = data['access_token']
    self.credit_card_status = true
    self.gateway_info = data
    self.save
  end
end
class User < ActiveRecord::Base
  include Unsubscribable

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable, :async
  validates_presence_of :name, :email
  validates :ga_code,  allow_blank: true,
  length: { is: 13 }, format: {with:/[Uu][Aa]-\d{8}-\d/,
  message: "Google Analitycs Code Not Valid." }

  has_many :orders
  has_many :products
  has_many :referrals
  has_many :referrals_payments

  validates_confirmation_of :password
  serialize :settings
  serialize :credit_card_info
  serialize :paypal_info
  before_create do
    self.currency = Upandsell::Application.config.default_currency
  end
  after_create :send_welcome_email

#   has_many :products do
#     def sales(period = nil)
#      Order.where(product_id:
#       self.ids, status: 'completed',
#       created_at: Date.today.at_beginning_of_month..Date.today.at_end_of_month).count
#    end

#    def earnings(admin= false, period = nil)
#     if admin
#      earnings = Order.where(status: 'completed',
#       created_at: Date.today.at_beginning_of_month..Date.today.at_end_of_month)
#      .group('date(created_at)')
#      .group('amount_currency')
#      .sum('amount_cents')
#    else
#      earnings = Order.where(product_id: self.ids, status: 'completed',
#       created_at: Date.today.at_beginning_of_month..Date.today.at_end_of_month)
#      .group('date(created_at)')
#      .group('amount_currency')
#      .sum('amount_cents')
#    end
#    user = proxy_association.owner
#    earnings_map = {}
#    acc_earns = Money.new(0, user.currency)

#    earnings.each do |day|
#     earns = Money.new(day[1], day[0][1])
#     c_earns = check_currency(earns, user)
#     earnings_map[day[0][0].to_time.to_i] = c_earns.cents
#     acc_earns += c_earns
#   end
#   days = {}
#   (Date.today.at_beginning_of_month..Date.today.at_end_of_month)
#   .map { |day| days[day.to_time.to_i] = 0 }

#   return [acc_earns,
#     days.merge(earnings_map){|key, oldval, newval| newval + oldval}]
#   end

#   private
#   def check_currency(money, user)

#     if money.currency == user.currency
#       return money
#     # if multiple currencies but are equal to base currency
#   #elsif money.currency ==  'EUR'
#    #base_earns = Order.where(product_id: self.ids, status: 'completed')
#    #.sum('amount_base_cents')
#    #return Money.new(base_earns, user.currency )
#     # no tricks, convert all currencies to user currency
#   else
#     return money.exchange_to(user.currency)
#   end

# end
# end

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
 true if self.email == 'rocco@galluzzo.me'
end

def send_welcome_email
  UserMailer.delay.welcome_email(self)
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
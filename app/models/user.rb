class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable, :async

  validates :ga_code, allow_blank: true,
  length: { is: 13 }, format: {with:/[Uu][Aa]-\d{8}-\d/,
  message: "Google Analitycs Code Not Valid." }

  validates_confirmation_of :password
  serialize :settings
  serialize :credit_card_info
  serialize :paypal_info


  def upgrade_to_pro(token)
    self.account_type = 'pro'
    self.subscription_token = token
    self.subscription_date = Time.now
    self.save
  end

  def downrade_to_base
    self.account_type = 'base'
    self.subscription_token = ''
    self.subscription_date = nil
    self.save
  end

  def unsubscribe_token(type)
    verifier =  ActiveSupport::MessageVerifier.new(
      URI::escape(Upandsell::Application.config.secret_key_base))
    token = verifier.generate("#{self.id}/#{type}")
    {user: self.id, type: type, signature: token}
  end


  def self.is_valid_token?(id, type, signature)
    User.find(id).unsubscribe_token(type)[:signature] == signature
  end

  def self.unsubscribe(id, type, signature)
    if self.is_valid_token?(id, type, signature)
      user = self.find id
      user.update_attribute :email_after_sale, false
    end
  end

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
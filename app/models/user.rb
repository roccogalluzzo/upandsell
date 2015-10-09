class User < ActiveRecord::Base
  include Unsubscribable
  include Subscribable

  has_many :orders
  has_many :products
  has_many :referrals
  has_many :referrals_payments
  has_many :coupons
  has_many :subscription_invoices

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :confirmable, :async, :omniauthable, :switch_user
  serialize :settings
  serialize :credit_card_info
  serialize :paypal_info
  serialize :custom_email_message, Hash
  serialize :createsend_token

  scope :newsletter, -> { where newsletter: true }
  scope :not_active, -> { where subscription_active: false }
  scope :active, -> { where subscription_active: true }


  validates_presence_of :name, :email
  validates_confirmation_of :password
  validates :ga_code,  allow_blank: true,
  length: { is: 13 }, format: {with:/[Uu][Aa]-\d{8}-\d/,
  message: "Google Analitycs Code Not Valid." }

  validates :credit_card_gateway, inclusion: { in: %w(Paymill Stripe Braintree) }, allow_blank: true


  mount_uploader :avatar, AvatarUploader


  before_create do
    self.currency = Upandsell::Application.config.default_currency.upcase
  end

  after_create :send_welcome_email
  after_create :add_to_mailchimp

  def admin?
    Rails.application.secrets.admins.include?(email)
  end

  def company?
    self.tax_code && self.business_type == 'company'
  end

  def beta_signup?
    true if self.created_at < '24-12-2014'.to_datetime
  end

  def credit_card_active?
    return true if self.credit_card && !self.credit_card_gateway.blank? && !self.credit_card_token.blank? && !self.credit_card_public_token.blank?
    false
  end

  def paypal_active?
    return true if self.paypal && !self.paypal_email.blank?
    false
  end

  def send_welcome_email
    UserMailer.delay.welcome_email(self.id)
  end

  def subscribed?
    #return false if self.subscription_end.nil?
    #self.subscription_end > Time.now
    true
  end

  def add_to_mailchimp
    UserMailchimpSync.perform_async(self.id)
  end

  def connect_paypal(email, token, token_secret)
    self.paypal = true
    self.paypal_email = email
    self.paypal_token = token
    self.paypal_token_secret = token_secret
    self.save
  end


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    info = auth[:info]
    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = info[:email] && (info[:verified] || info[:verified_email])
      email = info[:email]
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        if auth[:provider] == 'facebook'
          avatar_url = info[:image].gsub('http://','https://')
        else
          avatar_url = info[:image]
        end
        user = User.new(
          name: auth[:extra][:raw_info][:name],
          email: email,
          password: Devise.friendly_token[0,20],
          remote_avatar_url: avatar_url
          )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

end

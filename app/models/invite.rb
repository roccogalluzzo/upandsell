class Invite < ActiveRecord::Base

  before_create :generate_token
  before_create :set_attributes
  validates :email, email: true
  validates :email, uniqueness: true
  validates :email, presence: true
  scope :waiting, -> { where status: 'waiting' }
  scope :used, -> { where status: 'used' }
  scope :sent, -> { where status: 'sent' }
  private
  def set_attributes
    self.invitation_created_at = Time.now
    self.status = 'waiting' if self.status == nil
  end

  def generate_token
    self.invitation_token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

end
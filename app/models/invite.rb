class Invite < ActiveRecord::Base

  before_create :generate_token
  before_create :set_attributes
  validates :email, email: true
  private
  def set_attributes
    self.invitation_created_at = Time.now
    self.status = 'created' if self.status == nil
  end

  def generate_token
    self.invitation_token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

end
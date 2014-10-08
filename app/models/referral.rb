class Referral < ActiveRecord::Base

belongs_to :user
validates_presence_of :referer_id, :amount


end

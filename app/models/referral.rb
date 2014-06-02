class Referral < ActiveRecord::Base

validates_presence_of :referer_id, :user_id, :amount


end

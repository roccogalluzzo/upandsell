class Order < ActiveRecord::Base
  belongs_to :product
  monetize :amount_cents
end

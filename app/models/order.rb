class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer
  monetize :amount_cents
end

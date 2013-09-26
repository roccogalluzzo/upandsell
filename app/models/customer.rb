class Customer < ActiveRecord::Base
has_many :product, inverse_of: :customer
end

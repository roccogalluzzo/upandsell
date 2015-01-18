require "rails_helper"

describe Order do

  it "set first order numer to 1" do
    order = create(:order)
    order.status = 'completed'
    order.save

    expect(order.number).to eq(1)
  end

  it "increase order number by one" do
   order = create(:order)
   order.status = 'completed'
   order.save
   order_2 = create(:order)
   order_2.status = 'completed'
   order_2.save

   expect(order_2.number).to eq(2)
 end

 it " not increase order number by one if order is not completed" do
   order = create(:order)
   order.status = 'completed'
   order.save
   order_2 = create(:order)
   order_2.save

   expect(order.number).to eq(1)
 end

end

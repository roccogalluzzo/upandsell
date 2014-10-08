require "rails_helper"

describe Order do

  it "set first order numer to 1" do
    order = create(:order_completed)
    expect(order.number).to eq(1)
  end

  it "increase order number by one" do

    orders = create_list(:order_completed, 4, {user_id: 1})
    expect(orders[3].number).to eq(4)
  end

    it " not increase order number by one if order is not completed" do

    orders = create_list(:order_completed, 4, {user_id: 1})
    create(:order, {user_id: 1})
    expect(orders[3].number).to eq(4)
  end

end

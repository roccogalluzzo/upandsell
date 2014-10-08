require "rails_helper"

describe Metric do

  it "record sale" do
    product = create(:product)
    metric = Metric::Product.new(product)
    metric.record_sale(500)
    expect(metric.sales.get[:sales]).to eq(1)
  end

  it "remove sale" do
    product = create(:product)
    metric = Metric::Product.new(product)
    metric.record_sale(500)
    metric.delete_sale(500)
    expect(metric.sales.get[:sales]).to eq(0)
  end

  it "get today sales" do
    product = create(:product)
    metric = Metric::Product.new(product)
    metric.record_sale(500, 3.days.ago)
    metric.record_sale(500)
    expect(metric.sales.get[:data].first).to include({sales: 1, earnings: 500})
  end

  it "increment visit counter" do
    product = create(:product)
    metric = Metric::Product.new(product)
    metric.record_visit
    expect(metric.visits.get[:data].first[1]).to eq(1)
  end

  it "get today visits" do
    product = create(:product)
    metric = Metric::Product.new(product)
    metric.record_visit
    metric.record_visit
    metric.record_visit
    expect(metric.visits.get[:data].first[1]).to eq(3)
  end

  it "get today multiple products sales" do
    product = create(:product)
    product2 = create(:product)
    metric = Metric::Product.new(product)
    metric.record_sale(500)
    metric = Metric::Product.new(product2)
    metric.record_sale(500)
    sales = Metric::Product.new(Product.find(product.id,product2.id))
    expect(sales.sales.get[:data].first).to include({sales: 2 , earnings: 1000})
  end

  it "get today multiple products visits" do
    product = create(:product)
    product2 = create(:product)
    metric = Metric::Product.new(product)
    metric.record_visit
    metric = Metric::Product.new(product2)
    metric.record_visit
    visits = Metric::Product.new(Product.find(product.id,product2.id))
    expect(visits.visits.get[:data].first[1]).to eq(2)
  end

  it "get today  products sales exchanged currency" do
    product = create(:product)
    product2 = create(:product)
    Timecop.freeze(Time.local(2014, 6, 9)) do
      metric = Metric::Product.new(product)
      metric.record_sale(500)
      metric = Metric::Product.new(product2)
      metric.record_sale(500)
      sales = Metric::Product.new(Product.find(product.id,product2.id))
      expect(sales.sales.exchange_to(:usd).get[:data].first).to include({sales: 2 , earnings: 1364})
    end
  end
end
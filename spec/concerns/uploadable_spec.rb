require 'rails_helper'

shared_examples_for "uploadable" do
  let(:model) { described_class } # the class that includes the concern

  it "has a full name" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
    expect(person.full_name).to eq("Stewart Home")
  end
end
require "rails_helper"

describe User do

  it "return admin? true" do
    user = User.create(name: "User1", email: "rocco@galluzzo.me", password: "sanandreas")
    user.save
    expect(user.admin?).to eq(true)
  end

  it "return admin? false" do
    user = User.create(name: "User1", email: "roccoc@galluzzo.me", password: "sanandreas")
    user.save
    expect(user.admin?).to eq(false)
  end
end

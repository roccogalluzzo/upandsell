require 'rails_helper'

feature "Customer buy a product", js: true do
  background do
    create(:cc_user)
    visit login_path
  end

  context "when visiting product page" do
  end
end


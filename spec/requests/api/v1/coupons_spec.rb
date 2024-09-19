require 'rails_helper'

RSpec.describe "Coupons" do 
  before(:each) do
    @merchant = Merchant.create!(name: "Walmart")
    @coupon1  = Coupon.create!(name: "$10 dollars off", code: "10off", value: 10, status: true, merchant_id: @merchant.id )

    @customer = Customer.create!(first_name: "Billy", last_name: "Bob")
    @invoice1 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id, coupon_id: @coupon1.id, status: "shipped")
    @invoice2 = Invoice.create!(merchant_id: @merchant.id, customer_id: @customer.id, coupon_id: @coupon1.id, status: "packaged")
  end

  describe "coupons show action" do
    it "Returns a specific coupon and shows a count of how many times that coupon has been used." do
      get merchant_coupon_path(@merchant.id, @coupon1.id)

      expect(response).to be_successful
      coupon_response = JSON.parse(response.body, symbolize_names: true)

      expect(coupon_response).to have_key(:data)
      coupon = coupon_response[:data]

      binding.pry
    end
  end
end
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

      expect(coupon).to have_key(:type)
      expect(coupon[:type]).to eq('coupon')

      expect(coupon).to have_key(:id)
      expect(coupon[:id]).to be_an(String)

      expect(coupon).to have_key(:attributes)
      attributes = coupon[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to eq("$10 dollars off")

      expect(attributes).to have_key(:code)
      expect(attributes[:code]).to eq("10off")

      expect(attributes).to have_key(:value)
      expect(attributes[:value]).to eq(10)

      expect(attributes).to have_key(:status)
      expect(attributes[:status]).to eq(true)

      expect(attributes).to have_key(:use_count)
      expect(attributes[:use_count]).to eq(2)
    end

    it "returns a record not found if there is no coupon" do
      invalid_coupon_id = @coupon1.id + 1

      get merchant_coupon_path(@merchant.id, invalid_coupon_id)

      expect(response).to have_http_status(:not_found)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors][0][:status]).to eq("404")
      expect(data[:errors][0][:message]).to eq("Record not found.")
    end
  end
end
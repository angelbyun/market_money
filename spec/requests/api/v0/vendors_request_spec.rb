require 'rails_helper'

describe "Vendors API" do
  it "has a ist of all vendors" do
    @market_1 = create(:market)

    create_list(:vendor, 5, market_ids: @market_1.id, credit_accepted: true)

    get "/api/v0/markets/#{@market_1.id}/vendors"

    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors.count).to eq(5)

    vendors.each do |vendor|
      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      expect(vendor).to have_key(:id)
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes]).to have_key(:credit_accepted)
    end
  end

  it "displays error message if invalid id is passed" do
    @market_1 = create(:market)

    create_list(:vendor, 5, market_ids: @market_1.id, credit_accepted: true)

    get "/api/v0/markets/10989/vendors"

    expect(response).to_not be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({"error": "Couldn't find Market with 'id'=10989"})
  end

  it "validates vendor and all vendor attributes when valid id is passed" do
    @vendor_1 = create(:vendor)

    get "/api/v0/vendors/#{@vendor_1.id}"

    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors[:attributes][:name]).to eq(@vendor_1.name)
    expect(vendors[:attributes][:description]).to eq(@vendor_1.description)
    expect(vendors[:attributes][:contact_name]).to eq(@vendor_1.contact_name)
    expect(vendors[:attributes][:contact_phone]).to eq(@vendor_1.contact_phone)
    expect(vendors[:attributes][:credit_accepted]).to eq(@vendor_1.credit_accepted)
  end

  it "displays error message if invalid is passed" do
    @vendor_1 = create(:vendor)

    get "/api/v0/vendors/123432"

    expect(response).to_not be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({"error": "Couldn't find Vendor with 'id'=123432"})
  end
end
require 'rails_helper'

describe "Market Vendors API" do
  it "can create market vendors" do
    @market_1 = create(:market, id: 322474)
    create(:vendor, id: 54861, market_ids: @market_1.id)

    MarketVendor.delete_all
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: 322474, vendor_id: 54861)
    market_vendor = MarketVendor.last

    expect(response).to be_successful

    expect(market_vendor.market_id).to eq(322474)
    expect(market_vendor.vendor_id).to eq(54861)

    new_market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_market_vendor).to eq({"message": "Successfully added vendor to market"})
  end

  it "displays error message if invalid id is passed" do
    @market_1 = create(:market, id: 322474)
    create(:vendor, id: 54861, market_ids: @market_1.id)

    MarketVendor.delete_all
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: 123498, vendor_id: 54861)

    expect(response).to_not be_successful

    new_market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_market_vendor).to eq({"error": "Validation failed: Market must exist"})
  end

  it "displays error message if market vendor already exists" do
    @market_1 = create(:market, id: 322474)
    create(:vendor, id: 54861, market_ids: @market_1.id)

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: 322474, vendor_id: 54861)
    market_vendor = MarketVendor.last

    expect(response).to_not be_successful

    market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(market_vendor).to eq({"errors": [{"Validation failed": "Market vendor asociation between market with market_id=322474 and vendor_id=54861 already exists"}]})
  end
end
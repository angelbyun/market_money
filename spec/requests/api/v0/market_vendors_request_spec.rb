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

  it "can destroy a market vendor" do
    @market_1 = create(:market, id: 322474)
    @vendor_1 = create(:vendor, id: 54861)
    @market_vendor_1 = MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_1.id)

    expect(MarketVendor.find(@market_vendor_1.id)).to eq(@market_vendor_1)

    body = { market_id: @market_1.id, vendor_id: @vendor_1.id }
    delete "/api/v0/market_vendors", params: { market_vendor: body }

    expect(response).to be_successful

    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(@market_vendor_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "displays an error message if invalid id is passed" do
    @market_1 = create(:market, id: 322474)
    @vendor_1 = create(:vendor, id: 54861)
    @market_vendor_1 = MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_1.id)

    body = { market_id: 4233, vendor_id: 11520}
    delete "/api/v0/market_vendors", params: { market_vendor: body}

    expect(response).to_not be_successful
    expect(response.status).to be(404)
    expect{MarketVendor.find(4233)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{MarketVendor.find(11520)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
require 'rails_helper'

describe "Markets API" do
  it "has a list of all markets" do
    create_list(:market, 3)

    get "/api/v0/markets"

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes]).to have_key(:lon)
    end
  end

  it "has a vendor count for each market" do
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)

    create_list(:vendor, 5, market_ids: @market_1.id)
    create_list(:vendor, 3, market_ids: @market_2.id)
    create_list(:vendor, 7, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_1.id}"

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(markets[:attributes][:vendor_count]).to eq(5)
  end
end
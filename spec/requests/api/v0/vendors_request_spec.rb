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

  it "can create a new vendor" do
    vendor_params = ({
                      name: "Buzzy Bees",
                      description: "local honey and wax products",
                      contact_name: "Berly Couwer",
                      contact_phone: "8389928383",
                      credit_accepted: false
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last

    expect(response).to be_successful

    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "displays error message when not all attributes are filled" do
    vendor_params = ({
                      name: "Buzzy Bees",
                      description: "local honey and wax products",
                      credit_accepted: false
    })

    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    
    vendors = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to_not be_successful

    expect(vendors).to eq({"error": "Validation failed: Contact name can't be blank, Contact phone can't be blank"})
  end

  it "can update an existing vendor" do
    id = create(:vendor).id
    previous_vendor = Vendor.last.contact_name
    vendor_params = ({
                      contact_name: "Kimberly Couwer"
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    vendor = Vendor.find_by(id: id)

    expect(response).to be_successful

    expect(vendor.contact_name).to_not eq(previous_vendor)
    expect(vendor.contact_name).to eq("Kimberly Couwer")
  end

  it "displays error message if invalid id is passed" do
    create(:vendor).id
    Vendor.last.contact_name
    vendor_params = ({
                      contact_name: "Kimberly Couwer"
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/123456", headers: headers, params: JSON.generate({vendor: vendor_params})
    
    expect(response).to_not be_successful
    
    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({"error": "Couldn't find Vendor with 'id'=123456"})
  end

  it "displays error message when not all attributes are filled" do
    id = create(:vendor).id
    previous_vendor = Vendor.last.contact_name
    vendor_params = ({
                      contact_name: ""
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    vendor = Vendor.find_by(id: id)

    expect(response).to_not be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({"error": "Validation failed: Contact name can't be blank"})
  end
end
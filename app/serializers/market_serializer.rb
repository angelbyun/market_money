# frozen_string_literal: true

class MarketSerializer
  include JSONAPI::Serializer
  attributes  :name,
              :street,
              :city,
              :county,
              :state,
              :zip,
              :lat,
              :lon

  attribute :vendor_count do |vendor|
    vendor.vendors.count
  end
end

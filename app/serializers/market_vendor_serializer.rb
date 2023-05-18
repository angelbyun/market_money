# frozen_string_literal: true

class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes  :market_id,
              :vendor_id
end

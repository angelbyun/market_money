class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def self.vendor_count
    
  end
end
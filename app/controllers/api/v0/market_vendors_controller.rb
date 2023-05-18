class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if MarketVendor.where(params[:market_id] == :market_id && params[:vendor_id] == :vendor_id) != []
      render json: {"errors": [{"Validation failed": "Market vendor asociation between market with market_id=#{params[:market_id]} and vendor_id=#{params[:vendor_id]} already exists"}]}, status: 422
    elsif
      market_vendor.save
      render json: {"message": "Successfully added vendor to market"}
    else
      render json: MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params))
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: market_vendor_params[:market_id], vendor_id: market_vendor_params[:vendor_id])
    if market_vendor.nil?
      render json: {"errors": [{"detail": "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists"}]}, status: 404
    else
      market_vendor.delete
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end
# frozen_string_literal: true

module Api
  module V0
    class MarketsController < ApplicationController
      def index
        render json: MarketSerializer.new(Market.all)
      end

      def show
        render json: MarketSerializer.new(Market.find(params[:id]))
      end
    end
  end
end

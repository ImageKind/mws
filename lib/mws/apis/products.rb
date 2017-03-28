class Mws::Apis::Products
  def initialize(connection, overrides={})
    @connection = connection
    @param_defaults = {
      market: 'ATVPDKIKX0DER'
    }.merge overrides
    @option_defaults = {
      version: '2013-09-01'
    }
  end

  # Status for the product api. 'GREEN', 'YELLOW', 'RED'
  def status(params={})
    options = @option_defaults.merge action: 'GetServiceStatus'
    doc = @connection.get "/Products/#{options[:version]}", params, options
    doc.xpath('Status').first.text # return the status text
  end

  def list_matching_products(params={})
    options = @option_defaults.merge action: 'ListMatchingProducts'
    @connection.get "/Products/#{options[:version]}", params, options
  end

  def get_competitive_pricing_for_sku(params={})
    params[:Seller_SKU_List] ||= [ params.delete(:SellerSKUList) || [] ].flatten.compact
    options = @option_defaults.merge action: 'GetCompetitivePricingForSKU'
    @connection.get "/Products/#{options[:version]}", params, options
  end

  def get_competitive_pricing_for_asin(params={})
    params[:ASIN_List] ||= [ params.delete(:ASINList) || [] ].flatten.compact
    options = @option_defaults.merge action: 'GetCompetitivePricingForASIN'
    @connection.get "/Products/#{options[:version]}", params, options
  end

  def get_product_categories_for_asin(params={})
    options = @option_defaults.merge action: 'GetProductCategoriesForASIN'
    @connection.get "/Products/#{options[:version]}", params, options
  end
end

class Mws::Apis::Orders

  def initialize(connection, overrides={})
    @connection = connection
    @param_defaults = {
      market: 'ATVPDKIKX0DER'
    }.merge overrides
    @option_defaults = {
      version: '2013-09-01'
    }
  end

  # Status for the order api. 'GREEN', 'YELLOW', 'RED'
  def status(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'GetServiceStatus'
    doc = @connection.get "/Orders/#{options[:version]}", params, options
    doc.xpath('Status').first.text # return the status text
  end

  def get_order(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'GetOrder'
    doc = @connection.get "/Orders/#{options[:version]}", params, options

    doc.xpath('Orders/Order').map do | node |
      {
        :AmazonOrderId    => node.xpath('AmazonOrderId').text,
        :SellerOrderId    => node.xpath('SellerOrderId').text,
        :TotalAmount      => node.xpath('OrderTotal/Amount').text,
        :CurrencyCode     => node.xpath('OrderTotal/CurrencyCode').text,
        :BuyerName        => node.xpath('BuyerName').text,
        :BuyerEmail       => node.xpath('BuyerEmail').text,
        :OrderStatus      => node.xpath('OrderStatus').text,
        :OrderType        => node.xpath('OrderType').text,
        :SalesChannel     => node.xpath('SalesChannel').text,
        :OrderChannel     => node.xpath('OrderChannel').text,
        :ShipServiceLevel => node.xpath('ShipServiceLevel').text,
        :ShipmentServiceLevelCategory => node.xpath('ShipmentServiceLevelCategory').text,
        :PaymentMethod    => node.xpath('PaymentMethod').text,
        :PurchaseDate     => node.xpath('PurchaseDate').text.to_time,
        :LastUpdatedAt    => node.xpath('LastUpdatedAt').text.to_time,

        :shipping_address =>
        {
          :name             => node.xpath('ShippingAddress/Name').text,
          :street1          => node.xpath('ShippingAddress/AddressLine1').text,
          :street2          => node.xpath('ShippingAddress/AddressLine2').text,
          :street3          => node.xpath('ShippingAddress/AddressLine3').text,
          :city             => node.xpath('ShippingAddress/City').text,
          :county           => node.xpath('ShippingAddress/Country').text,
          :district         => node.xpath('ShippingAddress/District').text,
          :state_or_region  => node.xpath('ShippingAddress/StateOrRegion').text,
          :post_code        => node.xpath('ShippingAddress/PostalCode').text,
          :country_code     => node.xpath('ShippingAddress/CountryCode').text,
          :phone            => node.xpath('ShippingAddress/Phone').text
        }
      }
    end
  end

  def list(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact

    options = @option_defaults.merge action: 'ListOrders'
    doc = @connection.get "/Orders/#{options[:version]}", params, options

    response = []

    next_token = doc.xpath('NextToken').text

    doc.xpath('Orders/Order').map do | node |
      order = {
        :AmazonOrderId    => node.xpath('AmazonOrderId').text,
        :SellerOrderId    => node.xpath('SellerOrderId').text,
        :TotalAmount      => node.xpath('OrderTotal/Amount').text,
        :CurrencyCode     => node.xpath('OrderTotal/CurrencyCode').text,
        :BuyerName        => node.xpath('BuyerName').text,
        :BuyerEmail       => node.xpath('BuyerEmail').text,
        :OrderStatus      => node.xpath('OrderStatus').text,
        :OrderType        => node.xpath('OrderType').text,
        :SalesChannel     => node.xpath('SalesChannel').text,
        :OrderChannel     => node.xpath('OrderChannel').text,
        :ShipServiceLevel => node.xpath('ShipServiceLevel').text,
        :ShipmentServiceLevelCategory => node.xpath('ShipmentServiceLevelCategory').text,
        :PaymentMethod    => node.xpath('PaymentMethod').text,
        :PurchaseDate     => node.xpath('PurchaseDate').text.to_time,
        :LastUpdatedAt    => node.xpath('LastUpdatedAt').text.to_time,

        :shipping_address =>
        {
          :name             => node.xpath('ShippingAddress/Name').text,
          :street1          => node.xpath('ShippingAddress/AddressLine1').text,
          :street2          => node.xpath('ShippingAddress/AddressLine2').text,
          :street3          => node.xpath('ShippingAddress/AddressLine3').text,
          :city             => node.xpath('ShippingAddress/City').text,
          :county           => node.xpath('ShippingAddress/Country').text,
          :district         => node.xpath('ShippingAddress/District').text,
          :state_or_region  => node.xpath('ShippingAddress/StateOrRegion').text,
          :post_code        => node.xpath('ShippingAddress/PostalCode').text,
          :country_code     => node.xpath('ShippingAddress/CountryCode').text,
          :phone            => node.xpath('ShippingAddress/Phone').text
        }
      }

      response.push(order)
    end

    # TODO Throttling

    while !next_token.empty?
      params[:Next_Token] = next_token
      params.delete(:market)
      params.delete(:Created_After)
      params.delete(:Created_Before)
      options = @option_defaults.merge action: 'ListOrdersByNextToken'
      doc = @connection.get "/Orders/#{options[:version]}", params, options

      next_token = doc.xpath('NextToken').text

      doc.xpath('Orders/Order').map do | node |
        order = {
          :AmazonOrderId    => node.xpath('AmazonOrderId').text,
          :SellerOrderId    => node.xpath('SellerOrderId').text,
          :TotalAmount      => node.xpath('OrderTotal/Amount').text,
          :CurrencyCode     => node.xpath('OrderTotal/CurrencyCode').text,
          :BuyerName        => node.xpath('BuyerName').text,
          :BuyerEmail       => node.xpath('BuyerEmail').text,
          :OrderStatus      => node.xpath('OrderStatus').text,
          :OrderType        => node.xpath('OrderType').text,
          :SalesChannel     => node.xpath('SalesChannel').text,
          :OrderChannel     => node.xpath('OrderChannel').text,
          :ShipServiceLevel => node.xpath('ShipServiceLevel').text,
          :ShipmentServiceLevelCategory => node.xpath('ShipmentServiceLevelCategory').text,
          :PaymentMethod    => node.xpath('PaymentMethod').text,
          :PurchaseDate     => node.xpath('PurchaseDate').text.to_time,
          :LastUpdatedAt    => node.xpath('LastUpdatedAt').text.to_time,

          :shipping_address =>
          {
            :name             => node.xpath('ShippingAddress/Name').text,
            :street1          => node.xpath('ShippingAddress/AddressLine1').text,
            :street2          => node.xpath('ShippingAddress/AddressLine2').text,
            :street3          => node.xpath('ShippingAddress/AddressLine3').text,
            :city             => node.xpath('ShippingAddress/City').text,
            :county           => node.xpath('ShippingAddress/Country').text,
            :district         => node.xpath('ShippingAddress/District').text,
            :state_or_region  => node.xpath('ShippingAddress/StateOrRegion').text,
            :post_code        => node.xpath('ShippingAddress/PostalCode').text,
            :country_code     => node.xpath('ShippingAddress/CountryCode').text,
            :phone            => node.xpath('ShippingAddress/Phone').text
          }
        }

        response.push(order)
      end
    end

    response
  end
  alias_method :list_orders, :list

  # Call with :Amazon_Order_Id => 'xxyyzz' (from result of function list) to get the order items
  def list_items(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'ListOrderItems'
    doc = @connection.get "/Orders/#{options[:version]}", params, options

    doc.xpath('OrderItems/OrderItem').map do | node | {
        :OrderItemId      => node.xpath('OrderItemId').text,
        #TODO: Deprecate 'Amount'
        :Amount           => node.xpath('QuantityOrdered').text,
        :QuantityOrdered  => node.xpath('QuantityOrdered').text,
        :Sku              => node.xpath('SellerSKU').text,
        :Asin             => node.xpath('ASIN').text,
        :Title            => node.xpath('Title').text,

        :ItemPrice => {
          :Amount       => node.xpath('ItemPrice/Amount').text,
          :CurrencyCode => node.xpath('ItemPrice/CurrencyCode').text
        },
        :ItemTax => {
          :Amount       => node.xpath('ItemTax/Amount').text,
          :CurrencyCode => node.xpath('ItemTax/CurrencyCode').text
        },
        :ShippingPrice => {
          :Amount       => node.xpath('ShippingPrice/Amount').text,
          :CurrencyCode => node.xpath('ShippingPrice/CurrencyCode').text
        },
        :ShippingTax => {
          :Amount       => node.xpath('ShippingTax/Amount').text,
          :CurrencyCode => node.xpath('ShippingTax/CurrencyCode').text
        },
        :ShippingDiscount => {
          :Amount       => node.xpath('ShippingDiscount/Amount').text,
          :CurrencyCode => node.xpath('ShippingDiscount/CurrencyCode').text
        },
        :CODFee => {
          :Amount       => node.xpath('CODFee/Amount').text,
          :CurrencyCode => node.xpath('CODFee/CurrencyCode').text
        },
        :CODFeeDiscount => {
          :Amount       => node.xpath('CODFeeDiscount/Amount').text,
          :CurrencyCode => node.xpath('CODFeeDiscount/CurrencyCode').text
        },
        :GiftWrapPrice => {
          :Amount       => node.xpath('GiftWrapPrice/Amount').text,
          :CurrencyCode => node.xpath('GiftWrapPrice/CurrencyCode').text
        },
        :GiftWrapTax => {
          :Amount       => node.xpath('GiftWrapTax/Amount').text,
          :CurrencyCode => node.xpath('GiftWrapTax/CurrencyCode').text
        },
        :PromotionDiscount => {
          :Amount       => node.xpath('PromotionDiscount/Amount').text,
          :CurrencyCode => node.xpath('PromotionDiscount/CurrencyCode').text
        },
        :PromotionIds => node.xpath('PromotionIds').text,
        :PromotionId  => node.xpath('PromotionId').text
      }
    end
  end
  alias_method :list_order_items, :list_items

  # Sends order fulfillment details to amazon
  # Needed: amazon_order_id, carrier_code, shipping_method, shipping_tracking_number
  # Optional: merchant_order_id, fulfillment_date, shipping_tracking_number
  #
  # orders = {:amazon_order_id => 123,    :order_items => [{:order_item_id => 124,          :quantity => 125}] }
  #   OR
  # orders = {:merchant_order_id => 123,  :order_items => [{:merchant_order_item_id => 124, :quantity => 125}] }
  def send_fulfillment_data(params, orders)
    raise Mws::Errors::ValidationError.new('orders must be an array')         unless orders.is_a?(Array)
    raise Mws::Errors::ValidationError.new('An *_order_id is needed')         unless (orders.first.has_key?(:amazon_order_id) || orders.first.has_key?(:merchant_order_id))
    raise Mws::Errors::ValidationError.new('An *_order_id is needed')         unless (orders.first[:amazon_order_id].present? || orders.first[:merchant_order_id].present?)
    raise Mws::Errors::ValidationError.new('A carrier_code is needed')        unless orders.first.has_key?(:carrier_code) && orders.first[:carrier_code].present?
    raise Mws::Errors::ValidationError.new('A shipping_method is needed')     unless orders.first.has_key?(:shipping_method) && orders.first[:shipping_method].present?
    raise Mws::Errors::ValidationError.new('orders must be a array.')         unless orders.is_a?(Array)
    raise Mws::Errors::ValidationError.new('At least one order is needed.')   if orders.count == 0
    raise Mws::Errors::ValidationError.new('order_items must be a array.')    unless orders.first[:order_items].is_a?(Array)
    raise Mws::Errors::ValidationError.new('order_items must be a array.')    if orders.first[:order_items].count == 0

    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact

    order_xml = Nokogiri::XML::Builder.new do | xml |
      xml.AmazonEnvelope('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:noNamespaceSchemaLocation' => 'amznenvelope.xsd') {
        xml.Header {
          xml.DocumentVersion '1.01'
          xml.MerchantIdentifier params[:merchant_identifier]
        }
        xml.MessageType 'OrderFulfillment'

        orders.each_with_index do |order, index|
          xml.Message {
            xml.MessageID index+1

            xml.OrderFulfillment {
              xml.AmazonOrderID         order[:amazon_order_id]         if order.has_key?(:amazon_order_id)
              xml.MerchantOrderID       order[:merchant_order_id]       if order.has_key?(:merchant_order_id)
              xml.MerchantFulfillmentID order[:merchant_fulfillment_id] if order.has_key?(:merchant_fulfillment_id)
              xml.FulfillmentDate       order.has_key?(:fulfillment_date) ? order[:fulfillment_date] : Time.now.iso8601

              xml.FulfillmentData {
                xml.CarrierCode           order[:carrier_code]
                xml.ShippingMethod        order[:shipping_method]
                xml.ShipperTrackingNumber order[:shipper_tracking_number]
              }

              order[:order_items].each do | item |
                xml.Item {
                  xml.AmazonOrderItemCode item[:amazon_order_item_code]   if item.has_key?(:amazon_order_item_code)
                  xml.MerchantOrderItemID item[:merchant_order_item_id]   if item.has_key?(:merchant_order_item_id)
                  xml.Quantity            item[:quantity]
                }
              end
            }
          }
        end
      }
    end.to_xml

    @connection.feeds.submit order_xml, {:feed_type => :order_fulfillment}
  end


  # Sends order acknowledgement details to Amazon
  # Needed: amazon_order_id, merchant_order_id, status_code
  #
  # orders = [{:amazon_order_id => '123', :merchant_order_id => 'XYZ', :status_code => 'success' }]
  def send_acknowledgement(params, orders)
    # Validations
    raise Mws::Errors::ValidationError.new('orders must be an array')                 unless orders.is_a?(Array)
    raise Mws::Errors::ValidationError.new('amazon_order_id entries are required')    if orders.collect{|o| o.has_key?(:amazon_order_id)}.include? false
    raise Mws::Errors::ValidationError.new('merchant_order_id entries are required')  if orders.collect{|o| o.has_key?(:merchant_order_id)}.include? false
    raise Mws::Errors::ValidationError.new('status_code must be success or failure')  if orders.collect{|o| o[:status_code] == 'Success' || o[:status_code] == 'Failure'}.include? false

    message_number = 0

    order_xml = Nokogiri::XML::Builder.new do | xml |
      xml.AmazonEnvelope('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:noNamespaceSchemaLocation' => 'amznenvelope.xsd') {
        xml.Header {
          xml.DocumentVersion '1.01'
          xml.MerchantIdentifier params[:merchant_identifier]
        }
        xml.MessageType 'OrderAcknowledgement'

        orders.each do | order |
          xml.Message {
            xml.MessageID (message_number+=1).to_s
            xml.OrderAcknowledgement {
              xml.AmazonOrderID     order[:amazon_order_id]
              xml.MerchantOrderID   order[:merchant_order_id]
              xml.StatusCode        order[:status_code]
              order[:order_items].each do | item |
                xml.Item {
                  xml.AmazonOrderItemCode item[:amazon_order_item_id]
                  xml.MerchantOrderItemID item[:merchant_order_item_id]
                }
              end
            }
          }
        end
      }
    end.to_xml

    @connection.feeds.submit order_xml, {:feed_type => :order_acknowledgement}
  end
end

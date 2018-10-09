class SwishService
  BASE_URL = "https://cpc.getswish.net"
  CALLBACK_URL = Rails.application.secrets.swish_callback_url
  #PAYEE_ALIAS = "1231181189"
  PAYEE_ALIAS = "1236632400".freeze

  include PerformerService

  private
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def perform
    return F.new("Swish phone number is missing") unless order.swish_number

    response = create_payment_request(
      payer_alias: payer_alias_for(order.swish_number),
      amount: order.calculate_total
    )

    return F.new(errors_for(response)) unless response.status == 201
    swish_payment = SwishPayment.create!(
      payment_id: payment_id_for(response), order_id: order.id
    )

    order.update(
      order_id: Order.completed.maximum(:order_id) ? Order.completed.maximum(:order_id) + 1 : 1
    )

    return S.new(response: response, swish_payment: swish_payment)
  end

  def payment_deails_for(id)
    connection.get "/swish-cpcapi/api/v1/paymentrequests/#{id}"
  end

  def create_payment_request(payer_alias:, amount:)
    connection.post "/swish-cpcapi/api/v1/paymentrequests", {
      "callbackUrl" => CALLBACK_URL,
      "payeeAlias" => PAYEE_ALIAS,
      "currency" => "SEK",
      "payeePaymentReference" => @order.id,
      "payerAlias" => payer_alias,
      "amount" => amount.to_s,
      "message": "WaterAid Gåvoshop"
    }
  end

  def errors_for(response)
    response.body.map{|error_object|
      "#{error_object["errorCode"]} - #{error_object["errorMessage"]}"
    }
  end

  def payment_id_for(response)
    response.headers["location"].split("/").last
  end

  def payer_alias_for(swish_number)
    if swish_number.start_with?('+')
      return swish_number.gsub('+', '')
    elsif swish_number.starts_with?('0')
      return "46#{swish_number[1..-1]}"
    end
  end

  def connection
    Faraday.new(url: BASE_URL, ssl: ssl_options) do |conn|
      conn.request :json
      conn.response :logger
      conn.response :json, :content_type => /\bjson$/
      conn.adapter :net_http
    end
  end

  def cert_store
    return OpenSSL::X509::Store.new if Rails.env.test?

    return @@store if defined?(@@store)

    store = OpenSSL::X509::Store.new
    #store.set_default_paths

    #add cert seems to be buggy :(
    #store.add_cert OpenSSL::X509::Certificate.new(ca_cert)
    #store.add_cert OpenSSL::X509::Certificate.new(pem_cert)
    File.write("/tmp/ca.pem", ca_cert)
    store.add_file("/tmp/ca.pem")
    File.delete("/tmp/ca.pem")

    File.write("/tmp/swish.pem", pem_cert)
    store.add_file("/tmp/swish.pem")
    File.delete("/tmp/swish.pem")

    return @@store = store
  end

  def pem_cert
    ENV["SWISH_PEM"]
  end

  def private_key
    ENV["SWISH_PRIVATE_KEY"]
  end

  def ca_cert
    ENV["SWISH_CA"]
  end

  def ssl_options
    return {} if Rails.env.test?

    {
      # Peer verification is true by default
      :verify => true,
      # Rarely needed. If you need to be explicit, set:
      #:verify_mode => OpenSSL::SSL::VERIFY_PEER,

      # Override SSL_CERT_FILE: the path to your CA bundle
      #:ca_file => ca_path,
      # Override SSL_CERT_DIR: the directory with individual cert files
      #:ca_path => '/path/to/certs/',

      # Optional. Store extra certificates that you will trust.
      :cert_store => cert_store,

      # Max length of cert chain to be verified
      :verify_depth => 3,

      # Rarely needed. Set client certificate and private key.
      client_cert: OpenSSL::X509::Certificate.new(pem_cert),
      client_key: OpenSSL::PKey::RSA.new(private_key),
    }
  end
end

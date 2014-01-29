module Billing
  module Paymill

   def self.config=(config)
    @@config = config
  end

  def self.config
    @@config
  end

  module Unite

    def self.auth_url
      config = Billing::Paymill.config
      query = {
        client_id: config[:client_id],
        scope: config[:scope],
        response_type: 'code'
        }.to_query

        URI::HTTPS.build(host: 'connect.paymill.com',
          path: '/authorize', query: query).to_s
      end
      def self.access_token(auth_code)
        config = Billing::Paymill.config

        body = {
          client_id: config[:client_id],
          client_secret: config[:client_secret],
          grant_type: "authorization_code",
          code: auth_code
          }.to_query

          uri = URI::HTTPS.build(host: 'connect.paymill.com',
            path: '/token')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.request_uri)
          request.body =  body
          res = ActiveSupport::JSON.decode(http.request(request).body)
          return res
        end
      end
    end
  end

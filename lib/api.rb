module API

  def self.api
    @api ||= Faraday.new(url: 'http://localhost:9292/api/v1') do |c|
      c.request :multipart
      c.request :url_encoded
      c.response :json
      c.adapter  Faraday.default_adapter
      c.use     API::Errors
    end
  end

  class Errors < Faraday::Response::Middleware

    def on_complete(env)
      if env[:status] == 404
        raise ActiveRecord::RecordNotFound
      end

      if env[:status] > 399
        raise  StandardError
      end
    end
  end


end
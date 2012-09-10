require "faraday"
require "faraday_middleware"

class Flickr
  class Client < Faraday::Connection
    DEFAULTS = {
      open_timeout: 3,
      timeout: 4
    }

    def initialize(access_token)
      api_key, shared_secret = Flickr.configuration.fetch(:api_key, :shared_secret)

      open_timeout = Flickr.configuration.open_timeout || DEFAULTS[:open_timeout]
      timeout      = Flickr.configuration.timeout      || DEFAULTS[:timeout]

      params = {
        url: 'http://api.flickr.com/services/rest',
        params: {
          format: 'json',
          nojsoncallback: '1',
          api_key: api_key
        },
        request: {
          open_timeout: open_timeout,
          timeout: timeout
        }
      }

      super(params) do |builder|
        # Request
        builder.use Middleware::Retry
        builder.use FaradayMiddleware::OAuth,
          consumer_key: api_key,
          consumer_secret: shared_secret,
          token: access_token.first,
          token_secret: access_token.last

        # Response
        builder.use Middleware::NormalizeData
        builder.use Middleware::CheckStatus
        builder.use FaradayMiddleware::ParseJson
        builder.use Middleware::CheckOAuth

        builder.adapter :net_http
      end
    end

    def for(scope)
      @scope = scope
      self
    end

    [:get, :post].each do |http_method|
      define_method(http_method) do |*args|
        flickr_method = args.first.is_a?(String) ? args.first : resolve_flickr_method
        params = args.last.is_a?(Hash) ? args.last : {}

        response = super() do |req|
          req.params[:method] = flickr_method
          req.params.update(params)
        end

        response.body
      end
    end

    private

    def resolve_flickr_method
      method_name = caller[1][/(?<=`).+(?='$)/]
      full_method_name =
        if @scope.instance_of?(Class)
          "#{@scope}.#{method_name}"
        else
          "#{@scope.class}##{method_name}"
        end
      Flickr.api_methods.find { |_, value| value.include?(full_method_name) }.first
    end
  end
end

require "flickr/client/middleware"
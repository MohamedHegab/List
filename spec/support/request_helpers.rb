module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
  	def api_key
	  	request.headers['ApiKey'] = "key=1d7801c576b33db841d59216d8cf91d4" 
		end

    def api_authorize(auth_key)
      request.headers['Authorization'] = auth_key
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = "#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
    	api_key
      api_response_format
    end
  end
end
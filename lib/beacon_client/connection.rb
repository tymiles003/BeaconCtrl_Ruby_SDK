module BeaconClient
  class Connection
    attr_reader :client

    # @param [BeaconClient::Client] client
    def initialize(client)
      @faraday ||= Faraday.new(BeaconClient.config.beacon_ctrl_uri)
      @client = client
    end

    def get(path)
      send_safety :get, uri(path)
    end

    def post(path)
      send_safety :post, uri(path)
    end

    def put(path)
      send_safety :put, uri(path)
    end

    def delete(path)
      send_safety :delete, uri(path)
    end

    # private

    def uri(path)
      URI.join(BeaconClient.config.beacon_s2s_uri, path)
    end

    def send_safety(method, path, args={})
      args[:auth_token] = @client.auth_token
      @faraday.send(method, path, args)
    rescue StandardError => error
      self.class.logger.error error.message
      self.class.logger.error error.backtrace.join("\n")
      nil
    end

    def self.logger
      @logger ||= ::Logger.new(STDOUT)
    end
  end
end
module BeaconClient
  class Resource < BeaconClient::Base
    def save(params={}, key=fetch_instance_key)
      return self.class.create(self.attributes) unless persist?
      response = self.class.connection.put(resource_name, self.attributes.merge(params))
      fetch_instance(response, key.to_s)
    end

    def delete(key=fetch_instance_key)
      response = self.class.connection.delete("#{resource_name}/#{id}")
      fetch_instance(response, fetch_instance_key.to_s)
    end

    class << self
      def find(id, key=fetch_instance_key)
        response = self.connection.get("#{resources_name}/#{id.to_i}")
        fetch_instance(response, key)
        instance.send :persist!
        instance
      end

      def all(key=fetch_collection_key)
        response = self.connection.get(resources_name)
        fetch_collection(response, key.to_s)
      end

      def create(params={}, key=fetch_instance_key)
        response = self.connection.post(resources_name, params)
        fetch_instance(response, key)
      end

      def connect!(user=nil)
        @@client ||= ::BeaconClient::Client.new(user || BeaconClient.config.user)
      end

      # @return [Faraday::Connection]
      def connection
        connect! unless defined? @@client
        @@client.connection
      end

      def fetch_instance_key
        @fetch_instance_key ||= resource_name
      end

      def fetch_instance_key=(fetch_instance_key)
        @fetch_instance_key = fetch_instance_key
      end

      def fetch_collection_key
        @fetch_collection_key ||= resources_name
      end

      def fetch_collection_key=(fetch_collection_key)
        @fetch_collection_key = fetch_collection_key
      end

      private

      # @param [Faraday::Response] response
      def log_response(response)
        BeaconClient.logger.warn "Response code: #{ response.status }"
        if response.headers['www-authenticate']
          BeaconClient.logger.warn "Error: #{response.headers['www-authenticate']}"
        else
          BeaconClient.logger.warn "Headers: #{ response.headers.to_json }"
        end
      end

      # @param [String] body
      def log_body(body)
        BeaconClient.logger.info "Response body:\n#{body}"
      end

      # @param [String] body
      def parse_body(body)
        body = body.to_s.strip
        log_body(body) if BeaconClient.config.debug?
        body.size > 0 ? JSON.parse(body) : nil
      end

      # @param [Faraday:Response] response
      # @param [String] key
      def fetch_instance(response, key=resource_name)
        log_response(response) if response.status > 299
        body = parse_body(response)
        params = body[key.to_s]
        instance = new(params)
        instance.errors = body['errors']
        instance.send(:persist!) if params
        instance
      end

      # @param [Faraday:Response] response
      # @param [String] key
      def fetch_collection(response, key)
        log_response(response) if response.status > 299
        body = parse_body(response.body)
        array = body && body[key] ? body[key] : []
        array.map do |json|
          instance = new json
          instance.send(:persist!)
          instance
        end
      end
    end
  end
end
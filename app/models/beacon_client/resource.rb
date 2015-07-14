module BeaconClient
  class Resource < BeaconClient::Base
    NoIDField = Class.new(StandardError)

    def save(params={}, key=self.class.fetch_instance_key)
      return self.class.create(self.attributes, key, self) unless persist?
      raise NoIDField unless attributes.key?('id')
      path = self.class.build_path(self.class.namespace, self.class.resources_name, id.to_i)
      params = self.attributes.merge(params)
      params.delete("id")
      response = self.class.connection.put(path, self.class.params_instance_key => params)
      self.class.send(:fetch_instance, response, key.to_s, self)
      errors.empty? && self
    end

    def delete(key=self.class.fetch_instance_key)
      path = self.class.build_path(self.class.namespace, self.class.resources_name, id.to_i)
      response = self.class.connection.delete(path)
      self.class.send(:fetch_instance, response, key.to_s, self)
      errors.empty? && self
    end

    class << self
      attr_accessor :namespace

      def find(id, key=fetch_instance_key)
        path = build_path(namespace, resources_name, id.to_i)
        response = self.connection.get(path)
        fetch_instance(response, key)
        instance.send(:persist!)
        instance
      end

      def all(key=fetch_collection_key)
        path = build_path(namespace, resources_name)
        response = self.connection.get(path)
        fetch_collection(response, key.to_s)
      end

      def create(params={}, key=fetch_instance_key, instance = nil)
        path = build_path(namespace, resources_name)
        response = self.connection.post(path, params_instance_key => params)
        instance = fetch_instance(response, key, instance)
        instance.errors.empty? && instance
      end

      def connect!(user=nil)
        @@client ||= ::BeaconClient::Client.new(user || BeaconClient.config.user)
      end

      # @return [Faraday::Connection]
      def connection
        connect! unless defined? @@client
        @@client
      end

      def fetch_instance_key
        @fetch_instance_key ||= resource_name
      end

      def fetch_instance_key=(key)
        @fetch_instance_key = key
      end

      def fetch_collection_key
        @fetch_collection_key ||= resources_name
      end

      def fetch_collection_key=(key)
        @fetch_collection_key = key
      end

      def params_instance_key
        @params_instance_key ||= resource_name
      end

      def params_instance_key=(key)
        @params_instance_key = key
      end

      def params_collection_key
        @params_collection_key ||= resources_name
      end

      def params_collection_key=(key)
        @params_collection_key = key
      end

      def build_path(*args)
        args.reject(&:nil?).join('/')
      end

      private

      # @param [Faraday::Response] response
      def log_response(response)
        BeaconClient.logger.warn("Response code: #{ response.status }")
        if response.headers['www-authenticate']
          BeaconClient.logger.warn("Error: #{response.headers['www-authenticate']}")
        else
          BeaconClient.logger.warn("Headers: #{ response.headers.to_json }")
        end
      end

      # @param [String] body
      def log_body(body)
        BeaconClient.logger.info "Response body: #{body.inspect}"
      end

      # @param [String] body
      def parse_body(body)
        body = body.to_s.strip
        log_body(body) if BeaconClient.config.debug?
        body.size > 0 ? JSON.parse(body) : nil
      rescue JSON::ParserError
        BeaconClient.logger.info("Response is not a JSON")
        nil
      end

      # @param [Faraday:Response] response
      # @param [String] key
      # @param [BeaconClient::Base] instance
      def fetch_instance(response, key=fetch_instance_key, instance=nil)
        log_response(response) if response.status > 299
        body = parse_body(response.body)
        instance ||= new
        if body
          instance.write_attributes(body[key.to_s])
          instance.send(:persist!) if body[key.to_s]
          body['errors'].each_pair do |k, v|
            instance.errors.add(k, v)
          end if body['errors']
        end
        instance
      end

      # @param [Faraday:Response] response
      # @param [String] key
      def fetch_collection(response, key=fetch_collection_key)
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
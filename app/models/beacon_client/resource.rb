###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

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

      # Send request for one record.
      # This is not always supported by API
      #
      # @param [Fixnum] id
      # @param [String] key
      # @return [BeaconClient::Resource]
      def find(id, key=fetch_instance_key)
        path = build_path(namespace, resources_name, id.to_i)
        response = self.connection.get(path)
        instance = fetch_instance(response, key)
        instance.send(:persist!)
        instance
      end

      # Send request for all available for user records.
      #
      # @param [Hash] params
      # @param [String] key
      # @return [Array<BeaconClient::Resource>]
      def all(params = {}, key=fetch_collection_key)
        path = build_path(namespace, resources_name)
        response = self.connection.get(path, params_collection_key => params)
        fetch_collection(response, key.to_s)
      end

      # Create new record
      #
      # @param [Hash] params
      # @param [String] key
      # @param [BeaconClient::Resource] instance - if given response will be written to this instance, otherwise new instance will be returned
      def create(params={}, key=fetch_instance_key, instance = nil)
        path = build_path(namespace, resources_name)
        response = self.connection.post(path, params_instance_key => params)
        instance = fetch_instance(response, key, instance)
        instance.errors.empty? && instance
      end

      # Create new connection between BeaconCtrl and Client
      #
      # @param [Object] user
      # @return [BeaconClient::Client]
      def connect!(user=nil)
        @@client ||= ::BeaconClient::Client.new(user || BeaconClient.config.user)
      end

      # Current connection with BeaconCtrl
      # If not exists will create new.
      #
      # @return [BeaconClient::Client]
      def connection
        connect! unless defined? @@client
        @@client
      end

      # JSON key in which are stored object data.
      #
      # @return [String]
      def fetch_instance_key
        @fetch_instance_key ||= resource_name
      end

      def fetch_instance_key=(key)
        @fetch_instance_key = key
      end

      # JSON key in which are stored objects data.
      #
      # @return [String]
      def fetch_collection_key
        @fetch_collection_key ||= resources_name
      end

      def fetch_collection_key=(key)
        @fetch_collection_key = key
      end

      # Request parameters root key
      #
      # @return [String]
      def params_instance_key
        @params_instance_key ||= resource_name
      end

      def params_instance_key=(key)
        @params_instance_key = key
      end

      # Request parameters root key
      #
      # @return [String]
      def params_collection_key
        @params_collection_key ||= resources_name
      end

      def params_collection_key=(key)
        @params_collection_key = key
      end

      # Join path attributes
      #
      # @return [String]
      def build_path(*args)
        args.reject(&:nil?).join('/')
      end

      private

      # Print information about failed request.
      #
      # @param [Faraday::Response] response
      def log_response(response)
        BeaconClient.logger.warn("Response code: #{ response.status }")
        if response.headers['www-authenticate']
          BeaconClient.logger.warn("Error: #{response.headers['www-authenticate']}")
        else
          BeaconClient.logger.warn("Headers: #{ response.headers.to_json }")
        end
      end

      # Create or update BeaconClient::Base instance from
      # given HTTP response.
      #
      # @param [Faraday:Response] response
      # @param [String] key
      # @param [BeaconClient::Base] instance
      def fetch_instance(response, key=fetch_instance_key, instance=nil)
        log_response(response) if response.status > 299
        body = response.parsed.is_a?(Hash) ? response.parsed : nil
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

      # Create or update BeaconClient::Base instances from
      # given HTTP response.
      #
      # @param [Faraday:Response] response
      # @param [String] key
      def fetch_collection(response, key=fetch_collection_key)
        log_response(response) if response.status > 299
        body = response.parsed.is_a?(Hash) ? response.parsed : nil
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
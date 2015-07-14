###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class SubResource < BeaconClient::Resource
    ParentClassMissing = Class.new(::StandardError)
    ParentIdMissing = Class.new(::StandardError)

    def save(parent_or_id, params = {}, key = fetch_instance_key)
      return self.class.create(parent_or_id, params, key, self) unless persist?
      path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
      params = attributes.merge(params)
      response = self.class.connection.put(path, params_instance_key => params)
      fetch_instance(response, key.to_s, self)
      errors.empty? ? self : false
    end

    def delete(parent_or_id, key=fetch_instance_key)
      path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
      params = attributes
      response = self.class.connection.delete(path, params_instance_key => params)
      fetch_instance(response, key.to_s, self)
      errors.empty? ? self : false
    end

    class << self
      def find(parent_or_id, id, key=fetch_instance_key)
        path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
        response = connection.get(path)
        fetch_instance(response, key.to_s)
        instance
      end

      def all(parent_or_id, params = {}, key = fetch_collection_key)
        path = build_path(*prepare_for_path_builder(parent_or_id))
        response = connection.get(path, params_collection_key => params)
        fetch_collection(response, key.to_s)
      end

      def create(parent_or_id, params={}, key = fetch_instance_key, instance = nil)
        path = build_path(*prepare_for_path_builder(parent_or_id))
        response = connection.post(path, params_instance_key => params)
        fetch_instance(response, key.to_s, instance)
      end

      def parent_class=(klass)
        @parent_class = klass
      end

      def parent_class
        @parent_class
      end

      def prepare_for_path_builder(parent_or_id)
        raise ParentClassMissing unless parent_class
        id = parent_or_id.respond_to?(:id) ? parent_or_id.id : parent_or_id
        raise ParentIdMissing unless id
        parent_resources = parent_class.resources_name
        [parent_resources, id, resources_name]
      end
    end
  end
end
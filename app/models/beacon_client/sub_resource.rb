module BeaconClient
  class SubResource < BeaconClient::Resource
    ParentClassMissing = Class.new(::StandardError)
    ParentIdMissing = Class.new(::StandardError)

    def save(parent_or_id, params = {}, key = fetch_instance_key)
      return self.class.create(parent_or_id, params, key) unless persist?
      path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
      response = self.class.connection.put(path, attributes.merge(params))
      fetch_instance(response, key.to_s)
    end

    def delete(parent_or_id, key=fetch_instance_key)
      path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
      response = self.class.connection.delete(path, attributes.merge(params))
      fetch_instance(response, key.to_s)
    end

    class << self
      def find(parent_or_id, id, key=fetch_instance_key)
        path = build_path(*prepare_for_path_builder(parent_or_id), id.to_i)
        response = connection.get(path)
        fetch_instance(response, key.to_s)
      end

      def all(parent_or_id, key = fetch_collection_key)
        path = build_path(*prepare_for_path_builder(parent_or_id))
        response = connection.get(path)
        fetch_collection(response, key.to_s)
      end

      def create(parent_or_id, params={}, key = fetch_instance_key)
        path = build_path(*prepare_for_path_builder(parent_or_id))
        response = connection.post(path, attributes.merge(params))
        fetch_instance(response, key.to_s)
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
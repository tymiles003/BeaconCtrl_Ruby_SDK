module BeaconClient
  class Relation
    attr_accessor :name, :class_name, :type

    def initialize(name, class_name, type=:many)
      self.name = name
      self.class_name = class_name
      self.type = type.to_s.to_sym
    end

    def define_access(owner)
      relation = self
      owner.send :define_method, name do
        instance_variable_get(:"@#{relation.name}") || relation.default_value
      end

      owner.send :define_method, "#{relation.name}=" do |params|
        value = relation.fetch(params)
        instance_variable_set(:"@#{relation.name}", value)
        send relation.name
      end
    end

    def fetch(params)
      type == :many ? fetch_many(params) : fetch_single(params)
    end

    def fetch_many(params)
      params.map { |p| klass.new p }
    end

    def fetch_single(params)
      klass.new params
    end

    def klass
      class_name.is_a?(Class) ?
        class_name :
        Object.const_get(class_name)
    end

    def default_value
      type == :many ? [] : nil
    end
  end
end
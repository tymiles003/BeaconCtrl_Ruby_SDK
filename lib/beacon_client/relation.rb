module BeaconClient
  # Wrap relation between given class and specified class.
  class Relation
    attr_accessor :name, :class_name, :type

    # @param [String] name
    # @param [String|Class] class_name
    # @param [Symbol] type
    def initialize(name, class_name, type=:many)
      self.name = name
      self.class_name = class_name
      self.type = type.to_s.to_sym
    end

    # Add relation methods to given class
    #
    # @param [Class] owner
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

    # Transform given Hash in instances of related class
    #
    # @param [Hash] params
    def fetch(params)
      type == :many ? fetch_many(params) : fetch_single(params)
    end

    # @param [Array] array
    def fetch_many(array)
      array.map { |p| klass.new(p) }
    end

    # @param [Hash] params
    def fetch_single(params)
      klass.new(params)
    end

    # @return [Class]
    def klass
      class_name.is_a?(Class) ?
        class_name :
        Object.const_get(class_name)
    end

    # @return [Array|NilClass]
    def default_value
      type == :many ? [] : nil
    end
  end
end
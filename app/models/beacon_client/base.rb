module BeaconClient
  class Base
    def initialize(params={})
      @attributes = {}
      params.each_pair do |key, value|
        public_send("#{key}=", value)
      end if params.is_a?(Hash)
    end

    def method_missing(name, *_, &block)
      BeaconClient.logger.warn "Unknown attribute #{name}, skipping..."
    end

    def attributes
      @attributes ||= {}
      @attributes.clone
    end

    def errors
      @errors ||= {}
    end

    def errors=(data)
      return unless data
      @errors.merge! data
      valid?
    end

    def valid?
      errors.keys.size == 0
    end

    def persist?
      !@attributes_cache.nil?
    end

    def changed?
      return false if @attributes_cache.nil?
      @attributes.any? do |(key, value)|
        @attributes_cache[key] != value
      end
    end

    private

    def persist!
      @attributes_cache = attributes.freeze
    end

    class << self
      attr_accessor :relations

      def attributes(*attrs)
        instance_eval "attr_accessor #{ attrs.map(&:inspect).join(', ') }"
        attrs.each do |attr|
          define_method(attr) do
            @attributes[attr]
          end

          define_method("#{attr}=") do |value|
            @attributes[attr] = value
          end
        end
      end

      def has_many(name, class_name)
        self.relations ||= []
        relation = Relation.new(name, class_name, :many)
        self.relations << relation
        relation.define_access self
      end

      def has_one(name, class_name)
        self.relations ||= []
        relation = Relation.new(name, class_name, :one)
        self.relations << relation
        relation.define_access self
      end

      def resource_name
        @resource_name ||= self.name.split('::').last.gsub(/[A-Z]|[a-z][A-Z]/) do |s|
          s.split('').map(&:downcase).join('_')
        end
      end

      def resource_name=(resource_name)
        @resource_name = resource_name
      end

      def resources_name
        @resources_name ||= if defined? Rails
                              resource_name.pluralize
                            else
                              s = resource_name
                              case s[-1]
                              when 'y' then s.gsub(/y$/, 'ies')
                              when 's' then s
                              else
                                s + 's'
                              end
                            end
      end

      def resources_name=(resources_name)
        @resources_name = resources_name
      end
    end
  end
end
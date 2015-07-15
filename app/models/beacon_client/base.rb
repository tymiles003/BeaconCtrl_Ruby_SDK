###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class Base
    def initialize(params={})
      @attributes = {}
      write_attributes(params)
    end

    def write_attributes(attributes)
      attributes.each_pair do |key, value|
        public_send("#{key}=", value)
      end if attributes.is_a?(Hash)
    end

    def method_missing(name, *_, &block)
      BeaconClient.logger.warn "#{self.class.name} unknown attribute #{name}, skipping..."
    end

    def attributes
      @attributes ||= {}
      @attributes.clone.freeze
    end

    def errors
      @errors ||= BeaconClient::Error.new
    end

    def valid?
      validate!
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

    def changes
      @attributes.reduce({}) do |memo, (key, value)|
        memo[key] = value unless @attributes_cache[key] == value
        memo
      end
    end

    private

    def validate!
      errors.clear
      self.class.validators.each do |validator|
        validator.validate(self)
      end
      errors.empty?
    end

    def persist!
      @attributes_cache = attributes.freeze
    end

    class << self
      attr_accessor :relations

      public

      def attributes(*attrs)
        attrs.each do |attr|
          define_method(attr) do
            @attributes[attr.to_s]
          end

          define_method("#{attr}=") do |value|
            @attributes[attr.to_s] = value
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

      def validates(*attrs)
        opts = attrs.pop
        attrs.each do |attr|
          validator = BeaconClient::Validator.new(attr, opts)
          validators << validator
        end
      end

      def validators
        @validators ||= []
      end
    end
  end
end

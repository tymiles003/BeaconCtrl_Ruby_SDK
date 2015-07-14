module BeaconClient
  class Validator
    attr_reader :attribute, :validations

    def initialize(attribute, validations={})
      @attribute = attribute
      @validations = {}.merge(validations)
    end

    def validate(object)
      @validations.each_pair do |name, value|
        if respond_to?(name)
          send(name, object, value)
        else
          custom_validation(object, name, value)
        end
      end
    rescue StandardError => error
      BeaconClient.logger.error error
      BeaconClient.logger.error error.backtrace.join("\n")
      false
    end

    def custom_validation(object, name, value)
      res = case value
            when true
              !object.public_send(attribute).nil?
            when Proc
              value.call(object.public_send(attribute), object, attribute)
            when String, Symbol
              object.send(value)
            when Class
              value.new.validate(object)
            when Regexp
              object.public_send(attribute).to_s.match(value)
            else
              true
            end
      object.errors.add(attribute, name) unless res
      true
    end

    def numericality(object, *)
      value = object.public_send(attribute)
      unless value.is_a?(Fixnum)
        object.errors.add(attribute, :numerical)
      end
    end

    def presence(object, *)
      value = object.public_send(attribute)
      if value.nil?
        object.errors.add(attribute, :presence)
      end
    end

    def format(object, regex)
      value = object.public_send(attribute)
      unless value.to_s.match(regex)
        object.errors.add(attribute, format: regex)
      end
    end
  end
end
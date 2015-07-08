module BeaconClient
  class Base
    def initialize(params={})
      params.each_pair do |key, value|
        public_send("#{key}=", value)
      end
    end

    def self.find(id)
      body = self.connection.get("#{resources_name}/#{id.to_i}").body.strip
    end

    def self.all
      body = self.connection.get(resources_name).body.strip
      body = JSON.parse body if body.size > 0

    end

    def self.resource_name
      self.name.split('::').last.gsub(/[A-Z]|[a-z][A-Z]/) do |s|
        s.split('').map(&:downcase).join('_')
      end
    end

    def self.resources_name
      if defined? Rails
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

    private

    class << self
      attr_accessor :auth, :connection

      def connect!(user=nil)
        @connection ||= ::BeaconClient::Connection.new(::BeaconClient::Client.new(user))
        self
      end
    end
  end
end
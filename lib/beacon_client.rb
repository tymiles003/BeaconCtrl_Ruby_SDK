module BeaconClient
  if defined? Rails
    extend ActiveSupport::Autoload

    require_relative './beacon_client/engine'

    autoload :Configuration
    autoload :Connection
    autoload :Client
  else
    require_relative './beacon_client/configuration'
    require_relative './beacon_client/connection'
    require_relative './beacon_client/client'
    require_relative './beacon_client/autoload'
  end

  def self.config
    @config ||= BeaconClient::Configuration.new
  end

  def self.configure
    yield config if block_given?
  end
end
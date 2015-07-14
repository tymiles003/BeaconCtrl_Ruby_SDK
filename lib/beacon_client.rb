module BeaconClient
  if defined? Rails
    extend ActiveSupport::Autoload

    require_relative './beacon_client/engine'

    autoload :Configuration
    autoload :Client
    autoload :Relation
    autoload :Validator
    autoload :Error
  else
    require_relative './beacon_client/configuration'
    require_relative './beacon_client/client'
    require_relative './beacon_client/relation'
    require_relative './beacon_client/validator'
    require_relative './beacon_client/error'
  end
  require_relative './beacon_client/autoload'

  def self.config
    @config ||= BeaconClient::Configuration.new
  end

  def self.configure
    yield config if block_given?
  end

  def self.logger
    @logger ||= ::Logger.new(STDOUT)
  end
end
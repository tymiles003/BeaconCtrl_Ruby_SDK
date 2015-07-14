###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

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

  # Connection configuration
  #
  # @return [BeaconClient::Configuration]
  def self.config
    @config ||= BeaconClient::Configuration.new
  end

  # Create config and yield given block.
  #
  # @return [BeaconClient::Configuration]
  def self.configure
    yield config if block_given?
  end

  # Current Client logger
  # By default this is ::Logger.new(STDOUT)
  #
  # @return [Logger]
  def self.logger
    @logger ||= ::Logger.new(STDOUT)
  end

  # @param [Logger] logger
  def self.logger=(logger)
    @logger = logger
  end
end
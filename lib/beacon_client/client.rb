###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  # OAuth2 wrapper
  class Client
    attr_reader :connection, :user, :auth_token

    # @param [Object] user - if given connection will be created for specific user (recommended)
    def initialize(user=nil)
      @user = user
      connect!
    end

    # CRUD get
    def get(path, params={})
      request(:get, path, params)
    end

    # CRUD put
    def put(path, params={})
      request(:put, path, params)
    end

    # CRUD post
    def post(path, params={})
      request(:post, path, params)
    end

    # CRUD delete
    def delete(path, params={})
      request(:delete, path, params)
    end

    # CRUD patch
    def patch(path, params={})
      request(:patch, path, params)
    end

    def refresh!
      connect! unless @connection
      conn = @connection.refresh!
      @connection = conn if conn
    end

    private

    # Sending request using OAuth2 + Faraday connection.
    # All credentials are automatically added.
    def request(word, path, params, repeat=1)
      if BeaconClient.config.debug?
        BeaconClient.logger.debug("Path: #{path.inspect}")
        BeaconClient.logger.debug("Params: #{params.inspect}")
      end
      response = connection.send(word, path, params: params)
      if BeaconClient.config.debug?
        BeaconClient.logger.debug("Params: #{response.inspect}")
      end
      response
    rescue OAuth2::Error => error
      BeaconClient.logger.error(error.message)
      error.response
    rescue
      refresh!
      repeat-=1
      retry if repeat >= 0
    end

    # Create new connection between BeaconCtrl and BeaconClient
    # New oauth token should be returned by server.
    def connect!
      @connection = user ? connection_for_user : connection_for_application
      @auth_token = @connection.token
      BeaconClient.logger.debug("Client token: #{@auth_token}") if BeaconClient.config.debug?
      @auth_token
    rescue OAuth2::Error => error
      BeaconClient.logger.error(error.message)
      BeaconClient.logger.error(error.backtrace.join("\n"))
    end

    # Connect as an application
    # No user credentials are required
    # Not recommended and poorly supported
    #
    # Require ApplicationID and ApplicationSecret
    def connection_for_application
      oauth_client.client_credentials.get_token
    end

    # Connect as an User
    #
    # Require ApplicationID, ApplicationSecret, UserEmail, UserPassword
    def connection_for_user
      BeaconClient.logger.debug([user.email.inspect, user.password.inspect].join(' : '))
      oauth_client.password.get_token(
        user.email, user.password,
        email: user.email
      )
    end

    # noinspection RubyArgCount
    def oauth_client # :nodoc:
      @oauth_client ||= ::OAuth2::Client.new(
        BeaconClient.config.client_id,
        BeaconClient.config.client_secret,
        site: BeaconClient.config.beacon_s2s_uri,
        token_url: URI.join(BeaconClient.config.beacon_s2s_uri, 'oauth/token'),
        authorize_url: URI.join(BeaconClient.config.beacon_s2s_uri, 'oauth/authorize_url')
      )
    end
  end
end

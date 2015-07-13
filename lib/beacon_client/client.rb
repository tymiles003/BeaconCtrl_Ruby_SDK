module BeaconClient
  class Client
    attr_reader :connection, :user, :auth_token

    def initialize(user=nil)
      @user = user
      connect!
    end

    def get(path, params={})
      connection.get path, params
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    def put(path, params={})
      connection.put path, params
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    def post(path, params={})
      connection.post path, params
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    def delete(path, params={})
      connection.delete path, params
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    def patch(path, params={})
      connection.patch path, params
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    private
    def connect!
      @connection = user ? connection_for_user : connection_for_application
      @auth_token = @connection.token
      BeaconClient.logger.info "Client token: #{@auth_token}"
    rescue OAuth2::Error => error
      BeaconClient.logger.error error.message
      BeaconClient.logger.error error.backtrace.join("\n")
    end

    def connection_for_application
      oauth_client.client_credentials.get_token
    end

    def connection_for_user
      puts [user.email, user.password].inspect
      oauth_client.password.get_token(
        user.email, user.password,
        email: user.email
      )
    end

    # noinspection RubyArgCount
    def oauth_client
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
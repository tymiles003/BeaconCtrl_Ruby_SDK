module BeaconClient
  class Client
    attr_reader :connection, :user, :auth_token

    def initialize(user=nil)
      @user = user
      connect!
    end

    private

    def connect!
      @auth_token = user ? connection_for_user : connection_for_application
    end

    def connection_for_application
      ::OAuth2::Strategy::ClientCredentials.new(oauth_client).get_token.token
    end

    def connection_for_user
      ::OAuth2::Strategy::Password.new(oauth_client).get_token(user.email, user.password).token
    end

    def oauth_client
      ::OAuth2::Client.new(
        BeaconClient.config.client_id,
        BeaconClient.config.client_secret,
        site: BeaconClient.config.beacon_s2s_uri,
        token_url: URI.join(BeaconClient.config.beacon_s2s_uri, 'oauth/token')
      )
    end
  end
end
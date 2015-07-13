module BeaconClient
  class Application < Resource
    attributes :id, :name, :uid, :secret, :test

    has_many :users, BeaconClient::Activity
  end
end
module BeaconClient
  class User < BeaconClient::Resource
    self.namespace = 'admin'
    self.fetch_collection_key = 'admins'
    self.fetch_instance_key = 'admin'

    attributes :id, :role, :email

    validates :email,
              presence: true,
              pattern: /[\w\.%+\-]+@[\w\.\-]+\.[A-Za-z]{2,4}/
  end
end
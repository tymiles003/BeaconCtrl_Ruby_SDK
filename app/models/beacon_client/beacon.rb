module BeaconClient
  class Beacon < Resource
    self.fetch_collection_key = 'ranges'

    attributes :id, :name, :proximity_id

    has_one :location, BeaconClient::Location
    has_one :zone, BeaconClient::Zone
  end
end
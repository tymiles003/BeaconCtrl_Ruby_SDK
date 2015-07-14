module BeaconClient
  class Beacon < Resource
    self.fetch_collection_key = 'ranges'
    self.fetch_instance_key = 'range'

    attributes :id, :name, :proximity_id, :uuid, :major, :minor

    has_one :location, BeaconClient::Location
    has_one :zone, BeaconClient::Zone

    validates :uuid,
              presence: true,
              format: /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

    validates :major, :minor,
              presence: true,
              numericality: true

    validates :name,
              presence: true
  end
end
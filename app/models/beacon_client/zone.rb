module BeaconClient
  class Zone < Resource
    attributes :id, :name, :color, :hex_color
    attributes :beacon_ids
    has_many :beacons, BeaconClient::Beacon

    validates :name, presence: true
  end
end
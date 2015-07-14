module BeaconClient
  class ZoneBeacon < BeaconClient::SubResource
    self.parent_class = BeaconClient::Zone

    self.resource_name = 'beacon'
  end
end
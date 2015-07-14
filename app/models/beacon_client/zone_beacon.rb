module BeaconClient
  class ZoneBeacon < BeaconClient::SubResource
    self.parent_class = BeaconClient::Zone
  end
end
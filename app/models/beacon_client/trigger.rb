module BeaconClient
  class Trigger < Resource
    attributes :id, :type, :event_type, :beacon_ids, :zone_ids, :test
  end
end
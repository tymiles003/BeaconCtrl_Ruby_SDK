###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class ZoneBeacon < BeaconClient::SubResource
    self.parent_class = BeaconClient::Zone

    self.resource_name = 'beacon'
    self.fetch_collection_key = 'ranges'
    self.fetch_instance_key = 'range'

    attributes :id
    attributes :name
    attributes :proximity_id
    attributes :location
    attributes :zone
    attributes :vendor
    attributes :protocol
    attributes :unique_id
  end
end

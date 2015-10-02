###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class ZoneNeighbour < BeaconClient::Resource
    self.resources_name = 'zone_neighbours'
    self.fetch_collection_key = false

    attributes :id
    attributes :label
    attributes :color

    def self.find(id)
      path = build_path(namespace, resources_name, id.to_i)
      response = self.connection.get(path)
      fetch_collection(response, fetch_collection_key) do |instance|
        instance.send(:persist!)
      end
    end
  end
end

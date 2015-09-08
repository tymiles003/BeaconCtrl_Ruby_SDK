###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class Beacon < Resource
    self.fetch_collection_key = 'ranges'
    self.fetch_instance_key = 'range'

    attributes :id, :name, :proximity_id, :uuid, :major, :minor, :protocol, :vendor, :device_type

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

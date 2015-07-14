###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class Trigger < Resource
    attributes :id, :type, :event_type, :beacon_ids, :zone_ids, :test
  end
end
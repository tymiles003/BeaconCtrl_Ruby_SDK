###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class Activity < SubResource
    self.parent_class = BeaconClient::Application

    attributes :id, :name, :scheme, :payload, :trigger

    has_one :trigger, BeaconClient::Trigger

    has_many :custom_attributes, BeaconClient::CustomAttribute
  end
end
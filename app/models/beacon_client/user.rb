###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  class User < BeaconClient::Resource
    self.namespace = 'admin'
    self.fetch_collection_key = 'admins'
    self.fetch_instance_key = 'admin'
    self.params_instance_key = 'admin'

    attributes :id, :role, :email
    attributes :password, :password_confirmation, :encrypted_password

    validates :email,
              presence: true,
              pattern: /[\w\.%+\-]+@[\w\.\-]+\.[A-Za-z]{2,4}/
  end
end

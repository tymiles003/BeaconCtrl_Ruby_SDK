###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

Rspec.describe BeaconClient::Zone do
  it 'should not have namespace' do
    expect(described_class.namespace).to be_nil
  end
end
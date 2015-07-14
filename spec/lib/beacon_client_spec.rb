###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

describe BeaconClient do
  it 'should have Engine' do
    expect { BeaconClient::Engine }.to_not raise_error
  end

  it 'should have Configuration' do
    expect { BeaconClient::Configuration }.to_not raise_error
  end

  it 'should have #config' do
    expect(BeaconClient).to respond_to :config
  end
end
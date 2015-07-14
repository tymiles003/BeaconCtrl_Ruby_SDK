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
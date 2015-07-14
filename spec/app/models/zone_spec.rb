describe BeaconClient::Zone do
  it 'should not have namespace' do
    expect(described_class.namespace).to be_nil
  end
end
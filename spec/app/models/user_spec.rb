describe BeaconClient::User do
  it 'should have namespace' do
    expect(described_class.namespace).to be_eql 'admin'
  end
end
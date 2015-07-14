# BeaconCtrl Client

## Usage

### Configuration

#### Using ruby API

```ruby
BeaconClient.configure do |config|
  config.user = OpenStruct.new(
    email: 'test@example.com',
    password: 'pass1234'
  )
  config.beacon_ctrl_uri = 'http://beaconcontrol-admin.staging.up-next.io'
  config.beacon_s2s_uri = 's2s_api/v1'
  config.client_id = 'asdya97sdh9a7ys9yad8syd'
  config.client_secret = 'ahsduiha9s8dhasgh9dhasudhagsiydgaisiduagsdig'
end
```

#### Using environment variables

* BEACON_CLIENT_ID
* BEACON_CLIENT_SECRET
* BEACON_CTRL_URI
* BEACON_CLIENT_USER_EMAIL
* BEACON_CLIENT_USER_PASSWORD
* BEACON_CLIENT_DEBUG

### Using resources

```ruby
BeaconClient::Application.all
BeaconClient::Zone.new(id: 3).delete
BeaconClient::Zone.new(name: 'example').save
BeaconClient::Application.create(name: 'example')
zone = BeaconClient::Zone.all.last
zone.name = 'some name'
zone.changed? #=> true
zone.valid? #=> true
zone.save # self or false if failed
```
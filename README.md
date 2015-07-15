# BeaconCtrl Client

## Usage

```ruby
gem 'beacon_client', git: 'git@github.com:upnext/BeaconCtrl_Ruby_SDK.git'
```

### Configuration

You can configure BeaconClient using Ruby API, by defining environment variables or create .env file which will contain does variables.

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
BeaconClient.logger = MyCustomLogger.new
```

```bash
# BeaconClient variables

BEACON_CLIENT_ID=ansda98sadsh98ahsd9ya98s
BEACON_CLIENT_SECRET=nasdy9a8shd98yhas9yd9ah9s9dabsdn98asd
BEACON_CTRL_URI=http://localhost:3001
BEACON_CLIENT_USER_EMAIL=admin@example.com
BEACON_CLIENT_USER_PASSWORD=test123$
BEACON_CLIENT_DEBUG=T
```
Environment variables:

* BEACON_CLIENT_ID              - OAuth2 application uniq id
* BEACON_CLIENT_SECRET          - OAuth2 application secret
* BEACON_CTRL_URI               - BeaconCtrl admin url
* BEACON_CLIENT_USER_EMAIL      - User email
* BEACON_CLIENT_USER_PASSWORD   - User password
* BEACON_CLIENT_DEBUG           - Add some additional request information if set to 'T'

### Using resources

```ruby
# BeaconClient::Resource.connect!
BeaconClient::Resource.connection #=> BeaconClient::Client instance
BeaconClient::Resource.connection.auth_token # Current connection OAuth2 token
BeaconClient::Application.all
BeaconClient::Zone.new(id: 3).delete
BeaconClient::Zone.new(name: 'example').save
BeaconClient::Application.create(name: 'example')
zone = BeaconClient::Zone.all.last
zone.attributes #=> frozen hash with all written attributes
zone.name = 'some name'
zone.changed? #=> true
zone.changes #=> {name: 'some name'}
zone.valid? #=> true
zone.save #=> self or false if failed
```

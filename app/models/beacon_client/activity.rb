module BeaconClient
  class Activity < SubResource
    self.parent_class = BeaconClient::Application

    attributes :id, :name, :scheme, :payload, :trigger

    has_one :trigger, BeaconClient::Trigger

    has_many :custom_attributes, BeaconClient::CustomAttribute
  end
end
module BeaconClient
  # Rails mountable engine
  class Engine < Rails::Engine
    initializer 'beacon_client' do |app|
      config.paths.keys.each do |key|
        config.paths[key].each do |path|
          app.config.paths[key] << path
        end
      end
    end
  end
end
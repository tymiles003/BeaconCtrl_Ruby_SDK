module BeaconClient
  module Autoload
    def self.path_to_name(path)
      path.
        gsub(/.+\/beacon_client\/app\/[^\/]+/, '').
        gsub(/\.rb$/, '').
        split('/').
        map(&:strip).
        select do |s|
        s.size > 0
      end.map do |str|
        str.gsub(/^[a-z]|_[a-z]/) do |s|
          s.split('').last.upcase
        end
      end.join('::').gsub(/(::)?BeaconClient::/, '').to_sym
    end
  end

  Dir[File.expand_path('../../..', __FILE__)+'/app/**/*.rb'].sort do |a, b|
    a.split('/').size <=> b.split('/').size # first shorter path
  end.each do |path|
    autoload BeaconClient::Autoload.path_to_name(path), path
  end
end
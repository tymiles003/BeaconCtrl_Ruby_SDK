module BeaconClient
  class Error
    def initialize
      @store = {}
    end

    def add(attr, msg)
      @store[attr] ||= []
      @store[attr] += [*msg]
    end

    def clear
      @store.each_key do |key|
        @store[key] = []
      end
    end

    def empty?
      !@store.any? do |(_, value)|
        !value.empty?
      end
    end

    def [](attr)
      @store[attr]
    end
  end
end
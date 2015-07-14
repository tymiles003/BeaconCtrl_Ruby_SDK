###
# Copyright (c) 2015, Upnext Technologies Sp. z o.o.
# All rights reserved.
#
# This source code is licensed under the BSD 3-Clause License found in the
# LICENSE.txt file in the root directory of this source tree.
###

module BeaconClient
  # Simple error storage
  class Error
    def initialize
      @store = {}
    end

    # @param [Symbol|String] attr
    # @param [Symbol|String|Hash] msg
    def add(attr, msg)
      @store[attr] ||= []
      @store[attr] += [*msg]
    end

    # Remove all validation messages
    def clear
      @store.each_key do |key|
        @store[key] = []
      end
    end

    # Check if any error exists
    def empty?
      !@store.any? do |(_, value)|
        !value.empty?
      end
    end

    # Access to attribute errors
    def [](attr)
      @store[attr]
    end
  end
end
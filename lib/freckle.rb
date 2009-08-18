require 'yajl' unless defined?(Yajl)
require 'streamly' unless defined?(Streamly)

module Apis
  module Freckle
    module ApiObject
      def initialize(hash)
        @hash = hash
      end
      
      def method_missing(method, *args)
        @hash[method.to_s]
      end
    end
  end
end

base = File.expand_path(File.dirname(__FILE__))
require base + '/freckle/base'
require base + '/freckle/project'
require base + '/freckle/entry'
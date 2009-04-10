require 'zlib' unless defined?(Zlib)
require 'curb' unless defined?(Curl)
require 'json' unless defined?(JSON)

module Apis
  module Freckle
    autoload :Base,                   'apis/freckle/base'
    autoload :Project,                'apis/freckle/project'
    autoload :Entry,                  'apis/freckle/entry'
    
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
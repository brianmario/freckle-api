module Apis
  module Freckle
    class Base
      def initialize(*args)
        if args.is_a?(Hash)
          @site_url = args[:site_url]
          @token = args[:token]
        elsif args.is_a?(Array)
          @site_url = args[0]
          @token = args[1]
        end
        unless @site_url.include?('.letsfreckle.com')
          @site_url += '.letsfreckle.com'
        end
        
        @curl = Curl::Easy.new
        @curl.headers["Accept-encoding"] = 'gzip, deflate'
        @curl.follow_location = true
        @curl.connect_timeout = 5
        @curl.timeout = 5
        @curl.dns_cache_timeout = 5
      end
      
      def projects
        @projects ||= begin
          json = get('/projects.json')
          projects_hash = JSON.parse(json)
          projects = []
          projects_hash.each do |project|
            projects << Project.new(project)
          end
          projects
        end
      end
      
      def entries
        @entries ||= begin
          json = get('/entries.json')
          entries_hash = JSON.parse(json)
          entries = []
          entries_hash.each do |entry|
            entries << Entry.new(entry)
          end
          entries
        end
      end
      
      def get(url)
        @curl.url = @site_url+'/api'+url+'?token='+@token
        @curl.perform
        return decode_content(@curl)
      end

      def decode_content(c)
        if c.header_str.match(/Content-Encoding: gzip/)
          gz =  Zlib::GzipReader.new(StringIO.new(c.body_str))
          xml = gz.read
          gz.close
        elsif c.header_str.match(/Content-Encoding: deflate/)
          xml = Zlib::Deflate.inflate(c.body_str)
        else
          xml = c.body_str
        end

        xml
      end
    end
  end
end
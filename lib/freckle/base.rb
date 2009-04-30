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
      end
      
      def projects(force=false)
        if force
          @projects = fetch_projects
        else
          @projects ||= fetch_projects
        end
      end
      
      def entries(force=false)
        if force
          @entries = fetch_entries
        else
          @entries ||= fetch_entries
        end
      end
      
      def get(url)
        uri = URI.parse('http://'+@site_url+'/api'+url+'?token='+@token)
        return Yajl::HttpStream.get(uri)
      end
      
      protected
        def fetch_projects
          projects_hash = get('/projects.json')
          projects = []
          projects_hash.each do |project|
            projects << Project.new(project)
          end
          projects
        end
        
        def fetch_entries
          entries_hash = get('/entries.json')
          entries = []
          entries_hash.each do |entry|
            entries << Entry.new(entry)
          end
          entries
        end
    end
  end
end
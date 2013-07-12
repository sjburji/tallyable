require 'net/http'
require 'nokogiri'

module Tallyable
	module ActsAsTallyable
		extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def acts_as_tallyable(options = {})
        # helper method for "POST" ing XML request to Tally
        def tally_request(tdl_file, host, port)
        	invalid_file = false
        	uri = URI.parse(host + ":" + port.to_s)
					http = Net::HTTP.new(uri.host, uri.port)

					request = Net::HTTP::Post.new(uri.request_uri)
					begin
						request.body = File.read(tdl_file)
						http.request(request)
					rescue
						nil
					end
        end
      end
    end
	end
end

ActiveRecord::Base.send :include, Tallyable::ActsAsTallyable

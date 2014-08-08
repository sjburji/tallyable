require 'net/http'
require 'nokogiri'

module Tallyable
  module ActsAsTallyable
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def acts_as_tallyable(host, port = 9002, options = {})
        @@host = host
        @@port = port
      end

      def employee_request
        response = tally_request("#{ File.dirname(__FILE__) }/employee_request.xml")
        employees = []

        if response.is_a? Hash
          xml = Nokogiri.XML(response.body)
          xml.xpath("ENVELOPE").each do |nodes|
            params = {}
            nodes.children.each do |node|
              params[:name] = node.text if node.name == "EMPPROFILENAME" 
              %w[EMPPROFILEEMAILID 
                EMPPROFILEGENDER 
                EMPPROFILEDATEOFBIRTH 
                EMPPROFILECONTACTNUMBER 
                EMPPROFILEEMPLOYEEADDRESS].each do |tag|
                  if node.at(tag)
                    case node.at(tag).name
                      when "EMPPROFILEEMAILID" 
                        params[:email] = node.at(tag).text
                      when "EMPPROFILEGENDER" 
                        params[:gender] = node.at(tag).text
                      when "EMPPROFILEDATEOFBIRTH" 
                        params[:date_of_birth] = node.at(tag).text
                      when "EMPPROFILECONTACTNUMBER" 
                        params[:phone] = node.at(tag).text
                      when "EMPPROFILEEMPLOYEEADDRESS" 
                        params[:address] = node.at(tag).text
                    end
                  end
              end

              # hack to find a record delimiter, hierarchical tags are better
              if node.name == "EMPPROFILESNO" and !params.empty?
                employees << params
                params = {}
              end
            end
            employees << params
          end
        end
        
        employees
      end

      private
      # helper method for "POST" ing XML request to Tally
      def tally_request(tdl_file)
        uri = URI.parse("#{ @@host }:#{ @@port }")
        http_handler = Net::HTTP.new(uri.host, uri.port)

        request_handler = Net::HTTP::Post.new(uri.to_s)
        begin
          request_handler.body = File.read(tdl_file)
          http_handler.request(request_handler)
        rescue Exception => e
          "#{e.message}"
        end
      end
    end    
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, Tallyable::ActsAsTallyable)
else
  include Tallyable::ActsAsTallyable
end

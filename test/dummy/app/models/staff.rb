class Staff < ActiveRecord::Base
  acts_as_tallyable

  attr_accessible :address, :date_of_birth, :email, :gender, 
  	:name, :phone

  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true
	validates :gender, :presence => true, :inclusion => 
		{ :in => ["Male", "Female"] }
	validates :date_of_birth, :presence => true
	validates :phone, :presence => true, :numericality => true
	validates :address, :presence => true

  # method to persist data
  def self.tally_persist_records(tdl_file, host, 
  	port = Settings.tally_port)
		staffs = Staffs.new
  	response = tally_request(tdl_file, host, port)
  	if response
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
			  	 	staffs << new(params)
			  	 	params = {}
				  end
				end
			  staffs << new(params)
			end
  		staffs.save
  	else
  		false
  	end
  end

  class Staffs < Array
	  include ActiveModel::Validations

	  def save
	    if self.map(&:valid?).all?
	      self.each(&:save!)
	      true
	    else
	      self.each_with_index do |staff, index|
	        staff.errors.full_messages.each do |message|
	          errors.add :base, "Row #{index + 1}: #{message}"
	        end
	      end
	      false
	    end
	  end
	end
end


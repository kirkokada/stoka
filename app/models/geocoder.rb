# Fetches Google Location data from a given address

class Geocoder

	include ActiveModel::Model

	attr_accessor :address

	def persisted?
		false
	end

	def initialize(address)
    @base_google_url = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address="
    @address = address
  end

  def location_data
  	@location_data ||= get_location_data
  end

  def get_location_data
  	uri = URI.parse(@base_google_url + @address)
  	response = Net::HTTP.get(uri)
  	Hash.from_xml(response.gsub("\n", ""))
  end

  def latitude
  	location_data['GeocodeResponse']['result']['geometry']['location']['lat']
  end

  def longitude
  	location_data['GeocodeResponse']['result']['geometry']['location']['lng']
  end
end
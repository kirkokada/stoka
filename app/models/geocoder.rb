# Fetches Google Location data from a given address

class Geocoder
  include ActiveModel::Model

  attr_accessor :uri

  BASE_GOOGLE_URL = 'http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address='

  def persisted?
    false
  end

  def initialize(address)
    @uri = URI.parse(base_google_url + address)
  end

  def location_data
    @location_data ||= set_location_data
  end

  def set_location_data
    response = Net::HTTP.get(uri)
    Hash.from_xml(response.gsub("\n", ''))
  end

  def latitude
    location_data['GeocodeResponse']['result']['geometry']['location']['lat']
  end

  def longitude
    location_data['GeocodeResponse']['result']['geometry']['location']['lng']
  end
end

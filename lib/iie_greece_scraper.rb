require 'open-uri'
require 'nokogiri'

class IIEGreeceScraper
  attr_reader :country, :country_id
  def initialize(query_params = {})
    @country = query_params[:country] || 'Greece'
    @country_id = country_id(country)
  end

  def country_id(country_name = nil)
    '1612'
  end

  def listings
    page_count = query_attributes[:page_count] 
    listings = [listings_for_page(initial_page)]

  end

  def iie_root 
    "http://iiepassport.org/"
  end  

  def initial_page
    uri = iie_root + "SearchResult.asp?show=&country=#{country_id}"
    @initial_page ||= Nokogiri::HTML(open(uri)) 
  end

  def listings_for_page(page_document)
    listings = page_document.css('#ListingMini')[0...(query_attributes[:per_page] - 1)]
    listings.map do |listing|
      program = listing.css('#companyname a').text
      {
        program: program,
        link: parse_link_from_listing(listing),
        institution: (listing.text.gsub(/#{program}/, "")).strip
      }
    end
  end

  def query_attributes
    listing_element = initial_page.css('td').select {|td| td.text.include?('Listings')}.first    
    element_text_array = listing_element.text.split(" ")

    per_page = element_text_array[3].to_i
    total = element_text_array[-1].to_i
    page_count = total / per_page
    {per_page: per_page, total: total, page_count: page_count}
  end

  private

  def parse_link_from_listing(listing)
    # the link on the listings page gets redirected with these params
    params = CGI.parse(listing.css('#companyname a').first['href'])
    iie_root + "Listing.asp?MDSID=#{params['PMDSID'].first}&AdListing=#{params['AdListingID'].first}" 
  end
end
require 'csv'
require 'json'
require 'nokogiri'



class CsvParser
  attr_accessor :csv_location, :html_location, :json_destination

  def initialize(csv_location, html_location, json_destination)
    @csv_location  = csv_location
    @html_location = html_location
    @json_destination = json_destination
  end

  def generate_json
    array_of_csv  = csv_to_array
    hash_of_links = parse_links_from_html
    array_with_links = replace_strings_with_links(array_of_csv, hash_of_links)
    json_array = array_with_links.to_json
  end
  
  def write_json
    File.open(json_destination, 'w+') do |f|
      f.write(generate_json)
    end
  end
  
  def csv_to_array
    csv_array = []
    CSV.open(csv_location, headers: true).each do |row|
      csv_array << row.to_hash
    end
    csv_array
  end

  def parse_links_from_html
    page = Nokogiri::HTML(File.read(html_location))
    links = page.css('a')
    links_hash = links.inject({}) {|hash, link| hash.merge(link.text => link['href'])}
  end

  def replace_strings_with_links(csv_array, hash_of_links) 
    csv_array.each do |row_hash|
      row_hash.each do |k,v|
        if href = hash_of_links[v]
          row_hash[k] = {text: v, href: href}
        end
      end
    end
  end
end




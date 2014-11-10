require 'csv'
require 'json'
require 'nokogiri'

csv_array = []
CSV.open('/home/nickp/Downloads/MASTERS IN GREECE (F).csv', headers: true).each do |row|
  csv_array << row.to_hash
end

page = Nokogiri::HTML(File.read('/home/nickp/Downloads/MASTERS IN GREECE (F).html'))
links = page.css('a')
links_hash = links.inject({}) {|hash, link| hash.merge(link.text => link['href'])}

csv_array.each do |row_hash|
  row_hash.each do |k,v|
    if href = links_hash[v]
      row_hash[k] = {text: v, href: href}
    end
  end
end

json_array = csv_array.to_json

File.open('masters_in_greece.json', 'w+') do |f|
  f.write(json_array)
end
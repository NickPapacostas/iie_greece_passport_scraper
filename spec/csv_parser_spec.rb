require 'csv_parser'

describe CsvParser do 
  let(:csv_location) { 
    File.expand_path("../fixtures/greece_masters_programs.csv", __FILE__)
  }
  let(:html_location) {
   File.expand_path("../fixtures/greece_masters_programs.html", __FILE__) 
  }

  let(:json_output_location){
    File.expand_path("../fixtures/masters_in_greece.json", __FILE__)  
  }

  let(:csv_parser){
    CsvParser.new(csv_location, html_location, 'test_json.json')
  }


  let(:first_link){
    Nokogiri::HTML(File.read(html_location)).css('a').first
  }

  describe '.csv_to_array' do 
    it 'creates an array of the csv' do 
      expect(csv_parser.csv_to_array.class).to eq(Array) 
    end

    it 'has an entry for each row' do 
      csv_file_length = File.open(csv_location).readlines.count - 1
      expect(csv_parser.csv_to_array.length).to eq(csv_file_length)
    end
  end

  describe 'parse_links_from_html' do 
    it 'returns a hash with link text for keys' do 
      expect(csv_parser.parse_links_from_html.first[0]).to eq(first_link.text)
    end

    it 'returns a hash with link href as values' do 
      expect(csv_parser.parse_links_from_html.first[1]).to eq(first_link['href'])
    end
  end

  describe 'replace_strings_with_links' do 
    it 'replaces csv value with hash if it matches a link' do 
      known_link_csv_column = 'TITLE OF THE PROGRAM'
      replaced_array = csv_parser.replace_strings_with_links(
        csv_parser.csv_to_array, csv_parser.parse_links_from_html)
      first_should_be_link = replaced_array.select do |h| 
        if h[known_link_csv_column].class == Hash
          h[known_link_csv_column][:text] == first_link.text 
        end
      end.first
      expect(first_should_be_link[known_link_csv_column][:href]).to eq(first_link['href'])
    end
  end

  it 'generates json output' do 
    expected_json = File.read(json_output_location)
    expect(csv_parser.generate_json).to eq(expected_json)
  end

end 
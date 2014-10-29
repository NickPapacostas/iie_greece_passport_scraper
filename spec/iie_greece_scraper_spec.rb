require 'iie_greece_scraper'
describe IIEGreeceScraper do 
  let(:scraper){IIEGreeceScraper.new()}
  let(:initial_page_html) {
    File.read(File.expand_path("../fixtures/greece_initial_page.html", __FILE__))
  }

  let(:initial_page_document){
    Nokogiri::HTML(initial_page_html)
  }

  before :each do 
    allow(scraper).to receive(:initial_page){
      initial_page_document
    }
  end


  it 'should initialize with a country' do 
    expect(scraper.country).to eq('Greece')
  end

  it 'should initialize with a country_id' do 
    expect(scraper.country_id).to eq('1612')
  end

  describe 'listings' do     
    it 'gets the initial page' do 
      expect(scraper.initial_page).to eq(initial_page_document)
    end

    it 'gets the page count' do 
      expect(scraper.query_attributes[:page_count]).to eq(8)
    end
  end

  describe 'listings for page' do 
    it 'creates an array of listing hashes' do 
      expect(scraper.listings_for_page(initial_page_document).first).to eq(
      {
        program: 'Athens Internship Program',
        link: 'http://iiepassport.org/Listing.asp?MDSID=IIE03-4245&AdListing=1202771',
        institution: 'Arcadia University, The College of Global Studies'
        })
    end
  end
end
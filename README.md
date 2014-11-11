iie_greece_passport_scraper
===========================

This is a little project to scrape the listings off iie passport for greece (http://iiepassport.org/SearchResult) 
Related to the fulbright generation study abroad initiative, trying to aggragate a listing of higher education programs from disparate sources. I eventually noticed that a) the passport search results were returning inaccurate search results (searching for 'greece' yielded programs in Paris) and b) the html of the page was virtually unparseable (dozens of '#miniList' elements, lists with different components seperated by random td's with a horizontal lines in it ) so I put that on hold (although I think I gave it a pretty good run for it's money).

A second component was parsing a csv into json and hosting it for angular on the front end (lib/csv_parser.rb). The CSV I recievd had hyperlinks in it, which I initially assumed would be a 'solved problem' kind of situation (which it is). But I had trouble using the [roo]('https://github.com/Empact/roo/') gem (pretty confident the issue was on my end). So I ended up writing a little 'parse and merge' script that takes an html copy of the csv and finds the hyperlinks and fills them into the normal csv processing. This was as much for my own fun as for anything else. 

Maybe it'll prove a lighterweight solution than the big csv converter gems out there for someone in the future just trying to parse a simple csv with some hyperlinks. But generally probably not the most useful thing I've built :)

Interface: 
```ruby
parser = CsvParser.new('path_to_csv.csv', 'path_to_csv_as_html.html', 'json_output_destination')
parser.generate_json

# or 

parser.write_json
```
Also see the spec for the nitty gritty if you're curious. 

Where I actually used the data: http://fulbright-greece-gsa.herokuapp.com/#/universities 

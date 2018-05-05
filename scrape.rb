require 'open-uri'
require 'nokogiri'
require 'openssl'



document = open'https://newyork.craigslist.org/search/cpg?query=app+developer&is_paid=all', {ssl_verify_mode: 0}
content = document.read

parse = Nokogiri::HTML(content)

rader =  parse.css('.content').css('.rows').css('.result-row').css('.result-info')

works = []

rader.each do |item|
  added_date =  item.css('.result-date').inner_text
  desc = item.css('.result-title').inner_text

  build = added_date + " " + desc

  works << build
end



puts "Hittade #{works.size} jobb med sökningen app developer!"

puts works



require 'open-uri'
require 'nokogiri'
require 'openssl'

require 'C:\Users\Daniel\RubymineProjects\untitled4\mailer2.rb'

page_nr = 1

base =    'https://jobb.blocket.se/lediga-jobb-i-stockholms-stad/'
page=     'sida' + page_nr.to_s
search =  '/?ks=freetext.hr'

url = base + page + search

document = open "#{url}", {ssl_verify_mode: 0}
content = document.read

doc = Nokogiri::HTML(content)

job_list = doc.css('[id="article-list"]').css('.job-item')

jobb = []

#Lägg in och kolla om sökningen får flera sidor och loopa igenom dessa och ta ut denna data

job_list.each do |item|

  rubrik =        item.css('.content a')[0].text.strip
  link =          "Link: " + item.css('.content a')[0]['href']
  arbetsgivare =  "Arbetsgivare: " + item.css('.content').css('div.extra.meta').css('a')[0].text.strip
  ort =           "Ort: " + item.css('.content').css('div.extra.meta').css('a')[1].text.strip
  kategori =      "Kategori: " + item.css('.content').css('div.extra.meta').css('a')[2].text.strip

  beskrivning = item.css('.content').css('div.description').css('a').text.strip
  #p beskrivning

  added = "Date added: " + item.css('.content').css('div.extra').css('span').text.strip
  #p added

  build_item = "#{rubrik} \n#{arbetsgivare} \n#{ort} #{kategori} #{added} \n#{beskrivning}\n\n #{link}"

  jobb << build_item

end

puts doc.css('div h2')[0].text.strip


puts "Antal hittade jobb som matchade sökningen: #{jobb.count}\n\n"



mailtext = "Totalt " + doc.css('div h2')[0].text.strip + "\n\nVi visar #{jobb.count} av dem."
mailtext << "\n"
jobb.each do |item|
  mailtext << "========================================================\n"
  mailtext << item
  mailtext << "\n========================================================\n"
end

mailtext << <<EOF

Hoppas att du hittade ett jobb du tyckte var intressant!
Glad påsk önskar teamet bakom dansjomailerJOBB

Vill du avprenumerera? Ring dansjomailer's kundtjänst på 0771-123 456 00

EOF

mailer = SMTPGoogleMailer.new
mailer.send_plain_email 'dansjomailer@gmail.com', 'dansjo_87@hotmail.com', doc.css('div h2')[0].text.strip, mailtext
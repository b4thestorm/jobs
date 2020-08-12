require 'nokogiri'
require 'open-uri'
require 'csv'

url = 'https://clutch.co/app-developers/nyc'


#scrape the front end of CLUTCH for company name and url

def company_name(position)
  "#block-system-main > div > div > div > section > div > div.row > div > div.service-page-rows > ul > li:nth-child(#{position}) > div > div.col-xs-12.col-md-10.bordered-right.provider-base-info > div.row.provider-row-header > div > h3 > a"
end
def company_url(position)
  "#block-system-main > div > div > div > section > div > div.row > div > div.service-page-rows > ul > li:nth-child(#{position}) > div > div.col-xs-12.col-md-2.provider-link-details > ul > li.website-link.website-link-a > a"
end

count = 0
#write to a jobs csv
CSV.open("/Users/arnoldsanders/desktop/jobs.csv", "a+") do |csv|
7.times do |num|
    if num == 0
       doc = Nokogiri::HTML(URI.open(url))

        while count < 21
         org_name = doc.at_css(company_name(count))
         org_link = doc.at_css(company_url(count))

         csv << [org_name.children[0].content] unless org_name.nil?
         csv << [org_link.attributes["href"].value] unless org_link.nil?
         count += 1
       end
     else
      #after processing the first page elements, append the page= query param
      doc = Nokogiri::HTML(URI.open(url + "?page=#{num}"))

      while count < 21
        #scrape for the links and titles on the proceeding pages
        org_name = doc.at_css(company_name(count))
        org_link = doc.at_css(company_url(count))

        csv << [org_name.children[0].content]  unless org_name.nil?
        csv << [org_link.attributes["href"].value] unless org_link.nil?
        count +=1
      end
    end
    count = 0
  end
end

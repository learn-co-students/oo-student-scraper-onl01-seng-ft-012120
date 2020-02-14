require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
    
  def self.scrape_index_page(index_url)
doc = Nokogiri::HTML(open(index_url))
    names = doc.search('h4').map(&:text)
    locations = doc.search('p').map(&:text)
    profiles = doc.css(".student-card a").map {|card| card['href']}
        students = names.zip(locations, profiles).map     {|na,lo,pro|{name:na,location:lo,profile_url:pro}}
        
    students
  end

def self.scrape_profile_page(profile_slug)
  profdoc = Nokogiri::HTML(open(profile_slug))
    student = {}
      binding.pry social = profdoc.css('div.social-icon-container a' binding.pry {|i|i['href']})
	        twit = social.select {|a| student[:twitter] = a unless !a.to_s.include?('twitter')} 
	        linked = social.select {|a| student[:linkedin] = a unless !a.to_s.include?('linkedin')}
	        github = social.select {|a| student[:github] = a unless !a.to_s.include?('github')}
	  if
	    student.length < social.length
	  then
	    blog = social.select {|a| student[:blog] = a}
	  end
   student[:profile_quote] = profdoc.css('div.profile-quote').children.to_s.delete('\\\"') unless profdoc.css('div.profile-quote').to_s.empty?
   student[:bio] = profdoc.css('p').children.text unless profdoc.css('p').children.text.empty?
 student
  end
end
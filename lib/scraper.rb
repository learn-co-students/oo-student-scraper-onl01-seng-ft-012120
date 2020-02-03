require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_array = []
    doc.css("div.student-card").each do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a").attribute("href").value
      student_array << student_hash
    end 
    student_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
     student_hash = {}
     all_links = doc.css('a')
     links_array = all_links.map {|element| element["href"]}.compact.drop(1)
    # binding.pry 
     links_array.each do |link|
      if link.include? "twitter"
        student_hash[:twitter] = link
      elsif link.include? "linkedin"
        student_hash[:linkedin] = link 
      elsif link.include? "github"
        student_hash[:github] = link
      else 
        student_hash[:blog] = link 
      end 
     end 
     student_hash[:profile_quote] = doc.css("div.profile-quote").text
     student_hash[:bio] = doc.css("div.bio-content p").text
    student_hash
  end

end

# github_link = links_array.detect { |link| link.to_s.include? "github" }
#     twitter_link = links_array.detect { |link| link.to_s.include? "twitter" }
#     linkedin_link = links_array.detect { |link| link.to_s.include? "linkedin" }

#     student_hash[:twitter] = twitter_link
#     student_hash[:linkedin] = linkedin_link
#     student_hash[:github] = github_link
#     student_hash[:blog] = links_array.last 
#     student_hash[:profile_quote] = doc.css("div.profile-quote").text
#     student_hash[:bio] = doc.css("div.bio-content p").text


# twitter   
#linkedin 
# github
# blog 
# profile_quote doc.css("div.profile-quote").text
# bio 

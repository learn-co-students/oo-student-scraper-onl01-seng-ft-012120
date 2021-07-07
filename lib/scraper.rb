require 'open-uri'
require 'pry'

class Scraper


  def self.scrape_index_page(index_url)
    students = []
    index_page = Nokogiri::HTML(open(index_url))
    index_page.css("div.roster-cards-container"). each do |card|
      card.css(".student-card a").each do |student| #student is all the information from the one card
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        student_profile_link = "#{student.attr('href')}"

        students << {name: student_name, location: student_location, profile_url: student_profile_link}

      end
    end
 
   students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
 

    profile_url = Nokogiri::HTML(open(profile_url))
    links = profile_url.css(".social-icon-container").children.css("a").map {|ele| ele.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else 
        student[:blog] = link
      end


      
    end
    student[:profile_quote] = profile_url.css(".profile-quote").text
    student[:bio] = profile_url.css("div.bio-content.content-holder div.description-holder p").text
    
    student
  end

end


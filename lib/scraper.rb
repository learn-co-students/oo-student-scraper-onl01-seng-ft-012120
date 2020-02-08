require 'open-uri'
require 'pry'
require "nokogiri"

class Scraper

  
  def self.scrape_index_page(index_url)

    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr("href")}"
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    #top level: doc.css("div.roster-cards-container")
    #card : card.css(".student-card a")
    #profile: student.attribute("href").value
    #name: student.css("h4.student-name").text
    #location: student.css("p.student-location").text
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}

    links = doc.css(".social-icon-container").css("a").map { |a| a["href"]}
    links.each { |link| 
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    }
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".description-holder p").text
    
    student

  end
end

# doc.css(".student-name").text
# doc.css(".student-location").text
# doc.css(".student-card").first.css("a").first.first[1]

# doc.css(".social-icon-container").css("a").first["href"]  ---  hrefs = doc.css(".social-icon-container a").map {|a| a["href"]}
# doc.css(".profile-quote").text
# doc.css(".description-holder p").text
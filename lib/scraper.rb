require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    #html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    array = []
    # array of hases w keys= :name, :location, :profile_url 
    #info doc.css("div.student.card")  but the second one
    # name: doc.css("h4.student-name").text
    #location: doc.css("p.student-location")
    # profile_url: doc.css("a").attribute("href").value

    doc.css("div.student-card").each do |student|
      student_hash = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
      array << student_hash
      #binding.pry
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    hash = {}
    i = 1
    while i < (doc.css("div.social-icon-container a").length + 1) do 
      index = i.to_s
      link = doc.css("div.social-icon-container a:nth-child(#{i})").attribute("href").value
      if link.include?("twitter")
        hash[:twitter] = link 
      elsif link.include?("linkedin")
        hash[:linkedin] = link 
      elsif link.include?("github")
        hash[:github] = link
      else 
        hash[:blog] = link
      end
        
      i += 1 
    end


    # hash = {
    #   :twitter => doc.css("div.social-icon-container a:nth-child(1)").attribute("href").value,
    #   :linkedin => doc.css("div.social-icon-container a:nth-child(2)").attribute("href").value,
    #   :github => doc.css("div.social-icon-container a:nth-child(3)").attribute("href").value,
    #   :blog => doc.css("div.social-icon-container a:nth-child(4)").attribute("href").value,
    #   :profile_quote => doc.css("div.profile-quote").text,
    #   :bio => doc.css("div.description-holder p").text,
    # }
    hash[:profile_quote] = doc.css("div.profile-quote").text
    hash[:bio] = doc.css("div.description-holder p").text

    hash

  end

end


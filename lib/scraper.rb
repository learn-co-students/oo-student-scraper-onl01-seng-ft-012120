require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    site = Nokogiri::HTML(open(index_url))

    student_array = []
    x = 0
    while x < site.css("div.student-card").length
      student_info = {}
      student_info[:name] = site.css("h4.student-name")[x].text
      student_info[:location] = site.css("p.student-location")[x].text
      student_info[:profile_url] = site.css("div.student-card a")[x].attributes["href"].value
      student_array << student_info
      x += 1
    end

    student_array
    #Student Name Array
    # site.css("h4.student-name")    add [index].text for name

    #Location Array
    # site.css("p.student-location")  add [index].text for location

    #Profile Page for First Student     cycle through the "0" for indices
    # site.css("div.student-card a")[0].attributes["href"].value
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    twitter = nil
    linkedin = nil 
    github = nil 
    blog = nil 
    
    keys = ["twitter", "linkedin", "github"]
    x = 0
    while x < profile.css("div.social-icon-container a").length
      social = profile.css("div.social-icon-container a")
        if social[x].attributes["href"].value.include?(keys[0])
          twitter = social[x].attributes["href"].value
        elsif social[x].attributes["href"].value.include?(keys[1])
          linkedin = social[x].attributes["href"].value
        elsif social[x].attributes["href"].value.include?(keys[2])
          github = social[x].attributes["href"].value
        else
          blog = social[x].attributes["href"].value
        end
        x += 1
    end
    profile_quote = profile.css("div.profile-quote").text
    bio = profile.css("div.description-holder p").text

    student_profile = {
                        :twitter => twitter, 
                        :linkedin => linkedin,
                        :github => github,
                        :blog => blog,
                        :profile_quote => profile_quote,
                        :bio => bio}
    student_profile.delete_if {|key, value| value == nil || value == []}
    student_profile
    #Socials Array - profile.css("div.social-icon-container a")
    #Profile Quote - profile.css("div.profile-quote").text
    #bio - profile.css("div.description-holder p").text
    
  end

end


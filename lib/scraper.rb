require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html= Nokogiri::HTML(open(index_url))
    html.css('.student-card').each do |card|
      inner_hash = {
        location: card.css('a .card-text-container p.student-location').text,
        name: card.css('a .card-text-container h4.student-name').text,
        profile_url: card.css('a').attribute('href').value
      }
      students << inner_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html= Nokogiri::HTML(open(profile_url))
    social_links = html.css('div.social-icon-container a')
    profile_quote = html.css('div.profile-quote').text
    bio = html.css('div.description-holder p').text
    student_info = {
      bio: bio,
      profile_quote: profile_quote
    }

    social_links.each do |link|
      symbol = link.css('img').attribute('src').value[14..-10]
      symbol = 'blog' if symbol == 'rss'
      student_info[symbol.to_sym] = link.attribute('href').value
    end
    student_info
  end

end
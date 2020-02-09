require 'pry'
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(attributes)
    attributes.each_pair { |key, value| self.send(("#{key}="), value) }
    @@all << self
    #binding.pry
  end

  def self.create_from_collection(attributes)
    attributes.each { |student_hash| self.new(student_hash) }
  end

  def add_student_attributes(attributes)
    attributes.each_pair { |key, value| self.send(("#{key}="), value) }
  end

  def self.all
    @@all
  end
end


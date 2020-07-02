require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    data = Nokogiri::HTML(open(index_url))
    students = data.css(".student-card").collect do |student|
      {
        :location => student.css(".student-location").text,
        :name => student.css(".student-name").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = Nokogiri::HTML(open(profile_url))
    info = {}
    student.css("a").each_with_index do |social, idx|
      if idx != 0
        link = social.attribute("href").value
        if link.include?("twitter")
          info[:twitter] = link
        elsif link.include?("linkedin")
          info[:linkedin] = link
        elsif link.include?("github")
          info[:github] = link
        else
          info[:blog] = link
        end
      end
    end
    info[:profile_quote] = student.css(".profile-quote").text
    info[:bio] = student.css("p").text
    info
  end

end
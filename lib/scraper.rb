require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css('.student-card').collect do |student|
      {
      name:student.css('.student-name').text,
      location:student.css('.student-location').text,
      profile_url:student.css('a').first.values[0]
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_hash = {}
    doc.css('.social-icon-container a').each do |link|
      case link['href']
      when /twitter.com/
        profile_hash[:twitter] = link['href']
      when /linkedin.com/
        profile_hash[:linkedin] = link['href']
      when /github.com/
        profile_hash[:github] = link['href']
      else
        profile_hash[:blog] = link['href']
      end
    end
    profile_hash[:profile_quote] = doc.css('.profile-quote').text
    profile_hash[:bio] = doc.css('.description-holder p').text
    profile_hash
  end
end

Scraper.scrape_index_page("https://learn-co-curriculum.github.io/student-scraper-test-page/")

hash = Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html")
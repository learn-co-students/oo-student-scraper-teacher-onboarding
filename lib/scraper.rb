require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_hash_array = []
    student_overview_page_html = Nokogiri::HTML(open(index_url))
    student_overview_page_html.css("div.roster-cards-container div.student-card").each do |student|
      student_hash_array << {
        :name => student.css("div.card-text-container h4.student-name").text,
        :location => student.css("div.card-text-container p.student-location").text,
        :profile_url => student.css("a")[0]['href']
      }
    end
    student_hash_array
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    student_profile_page_html = Nokogiri::HTML(open(profile_url))
    student_social_links_html = student_profile_page_html.css("div.main-wrapper.profile div.vitals-container div.social-icon-container a")
    # binding.pry
    student_profile_hash_array = {
      :profile_quote => student_profile_page_html.css("div.main-wrapper.profile div.vitals-container div.vitals-text-container div.profile-quote").text,
      :bio => student_profile_page_html.css("div.main-wrapper.profile div.details-container div.bio-block.details-block div.bio-content.content-holder div.description-holder p").text
    }
    student_social_links_html.each do |social_link|
      if social_link['href'].include?('twitter')
        student_profile_hash_array[:twitter] = social_link['href']
      elsif social_link['href'].include?('linkedin')
        student_profile_hash_array[:linkedin] = social_link['href']
      elsif social_link['href'].include?('github')
        student_profile_hash_array[:github] = social_link['href']
      else
        student_profile_hash_array[:blog] = social_link['href']
      end
    end
    # binding.pry
    student_profile_hash_array
  end

end


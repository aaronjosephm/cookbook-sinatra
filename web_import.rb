require "nokogiri"
require "open-uri"

class WebImport
  attr_reader :result, :result_details, :prep_times, :difficulties

  def initialize
    @result = []
    @result_details = []
    @prep_times = []
    @difficulties = []
  end

  def build(attributes = {})
    # age = attributes[:age]
    # ethnicity = attributes[:ethnicity]
    # height = attributes[:height]
    # body_type = attributes[:body_type]
    # for i in (0..100)
    url = "https://www.pof.com/viewprofile.aspx?profile_id=188544953"
    html_file = open(url).read
    doc = Nokogiri::HTML(html_file)
    attributes = {}
    puts "age: " + doc.search('#age').text
    puts "ethnicity " + doc.search('#ethnicity').text
    puts "height: " + doc.search('#height').text.split('"')[0]
    puts "body type: " + doc.search('#body').text
    attributes[:age] = doc.search('#age').text
    attributes[:ethnicity] = doc.search('#ethnicity').text
    attributes[:height] = doc.search('#height').text.split('"')[0]
    attributes[:body_type] = doc.search('#body').text
    return attributes
    # doc.search('.m_titre_resultat').each { |ele| @result << ele.text.strip }
    # doc.search('.m_texte_resultat').each { |ele| @result_details << ele.text.strip }
    # doc.search('.m_detail_time').each { |ele| @prep_times << ele.text.strip.split(" ")[1] }
    # doc.search('.m_detail_recette').each { |ele| difficulties << ele.text.strip.split("-")[2].strip }
    # end
  end
end

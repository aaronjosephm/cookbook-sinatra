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

  def build(recipe_name)
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{recipe_name}"
    html_file = open(url).read
    doc = Nokogiri::HTML(html_file)
    doc.search('.m_titre_resultat').each { |ele| @result << ele.text.strip }
    doc.search('.m_texte_resultat').each { |ele| @result_details << ele.text.strip }
    doc.search('.m_detail_time').each { |ele| @prep_times << ele.text.strip.split(" ")[1] }
    doc.search('.m_detail_recette').each { |ele| difficulties << ele.text.strip.split("-")[2].strip }
  end
end

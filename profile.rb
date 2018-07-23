class Profile
  attr_reader :age, :ethnicity, :height, :body_type, :url, :picture, :name, :interests
  attr_accessor :points

  def initialize(attributes = {})
    @age = attributes[:age]
    @ethnicity = attributes[:ethnicity]
    @height = attributes[:height]
    @body_type = attributes[:body_type]
    @url = attributes[:url]
    @picture = attributes[:picture]
    @name = attributes[:name]
    @interests = attributes[:interests]
    @points = 0
  end
end

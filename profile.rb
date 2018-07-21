class Profile
  attr_reader :age, :ethnicity, :height, :body_type

  def initialize(attributes = {})
    @age = attributes[:age]
    @ethnicity = attributes[:ethnicity]
    @height = attributes[:height]
    @body_type = attributes[:body_type]
  end
end

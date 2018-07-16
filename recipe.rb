require_relative "cookbook"

class Recipe
  attr_accessor :name, :description, :prep_time, :done, :difficulty

  def initialize(name, description, prep_time, done = " ", difficulty = "")
    @name = html_safe(name)
    @description = html_safe(description)
    @prep_time = html_safe(prep_time)
    @done = html_safe(done)
    @difficulty = html_safe(difficulty)
  end

  private
  def html_safe(par)
    if par.nil?
      return par
    else
      return par.gsub("<", "&lt;").gsub(">", "&gt;")
    end
  end
end

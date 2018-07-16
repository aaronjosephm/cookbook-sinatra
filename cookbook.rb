require_relative 'recipe'
require "csv"

class Cookbook
  attr_reader :list, :string_list

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @list = []
    tmp = CSV.open(@csv_file_path, 'r') { |csv| csv.read }
    tmp.each do |e|
      difficulty = ""
      difficulty = /\w+\:\s(\w+\s\w+|\w+)/.match(e[0])[0] unless /\w+\:\s\w+/.match(e[0]).nil?
      @list << Recipe.new(/(\w+|\w+\'\w)\s(\w+|\W)/.match(e[0])[0].gsub(" (", ""), e[1], /\d+/.match(e[0])[0], /\[(\s|\w)/.match(e[0])[0][1], difficulty)
    end
    @string_list = []
  end

  def all
    if @list.size > 0
      @list.each_with_index { |e, index| @string_list << "#{(index + 1).to_s} . #{e.name} (#{e.prep_time} min) [#{e.done}] #{e.difficulty}\n #{e.description}" }
    end
    return @list
  end

  def add_recipe(new_recipe)
    @list << new_recipe
    CSV.open(@csv_file_path, 'w') do |csv|
      @list.each do |row|
        csv.puts(["#{row.name} (#{row.prep_time} min) [#{row.done}] #{row.difficulty}", " #{row.description}"])
      end
    end
  end

  def remove_recipe(recipe_index)
    @list.delete_at(recipe_index.to_i - 1)
    CSV.open(@csv_file_path, 'w') do |csv|
      @list.each do |row|
        csv.puts(["#{row.name} (#{row.prep_time} min) [#{row.done}] #{row.difficulty}", " #{row.description}"])
      end
    end
  end

  def add_import(recipe_name, recipe_details, prep_time, difficulty)
    @list << Recipe.new(recipe_name, recipe_details, prep_time, " ", difficulty)
    CSV.open(@csv_file_path, 'w') do |csv|
      @list.each do |row|
        csv.puts(["#{row.name} (#{row.prep_time} min) [#{row.done}] #{row.difficulty}", " #{row.description}"])
      end
    end
  end

  def mark_recipe(recipe_index)
    @list[recipe_index.to_i - 1].done = "X"
    CSV.open(@csv_file_path, 'w') do |csv|
      @list.each do |row|
        csv.puts(["#{row.name} (#{row.prep_time} min) [#{row.done}] #{row.difficulty}", " #{row.description}"])
      end
    end
  end
end

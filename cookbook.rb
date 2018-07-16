require_relative 'recipe'
require "csv"

class Cookbook
  attr_reader :list, :string_list

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @list = []
    tmp = CSV.open(@csv_file_path, 'r') { |csv| csv.read }
    tmp.each do |e|
      @list << Recipe.new(e[0], e[4], e[1], e[2], e[3])
    end
    @string_list = []
  end

  def all
    if @list.size > 0
      @list.each_with_index { |e, index| @string_list << "#{(index + 1).to_s} . #{e.name} (#{e.prep_time} min.) [#{e.done}] difficulty: #{e.difficulty}" "\n Description: #{e.description}" }
    end
    return @list
  end

  def add_recipe(new_recipe)
    @list << new_recipe
    CSV.open(@csv_file_path, 'w', { force_quotes: true }) do |csv|
      @list.each do |row|
        csv << [row.name, row.prep_time, row.done, row.difficulty, row.description]
      end
    end
  end

  def remove_recipe(recipe_index)
    @list.delete_at(recipe_index.to_i - 1)
    CSV.open(@csv_file_path, 'w', { force_quotes: true }) do |csv|
      @list.each do |row|
        csv << [row.name, row.prep_time, row.done, row.difficulty, row.description]
      end
    end
  end

  def add_import(recipe_name, recipe_details, prep_time, difficulty)
    @list << Recipe.new(recipe_name, recipe_details, prep_time, " ", difficulty)
    CSV.open(@csv_file_path, 'w', { force_quotes: true }) do |csv|
      @list.each do |row|
        csv << [row.name, row.prep_time, row.done, row.difficulty, row.description]
      end
    end
  end

  def mark_recipe(recipe_index)
    @list[recipe_index.to_i - 1].done = "X"
    CSV.open(@csv_file_path, 'w', { force_quotes: true }) do |csv|
      @list.each do |row|
        csv << [row.name, row.prep_time, row.done, row.difficulty, row.description]
      end
    end
  end
end

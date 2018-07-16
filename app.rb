require_relative 'cookbook'
require_relative 'recipe'
require_relative 'web_import'
require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

set :bind, '0.0.0.0'
enable :sessions

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.all
  @usernames = cookbook.string_list
  erb :index
end

get '/new' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @usernames = cookbook.string_list
  erb :new
end

get '/list' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.all
  @usernames = cookbook.string_list
  erb :list
end

get '/destroy' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.all
  @usernames = cookbook.string_list
  erb :destroy
end

get '/import' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @usernames = cookbook.string_list
  erb :import
end

get '/mark' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.all
  @usernames = cookbook.string_list
  erb :mark
end

post '/new' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  recipe = Recipe.new(params[:recipe_name], params[:recipe_description], params[:prep_time], " ", "difficulty: #{params[:difficulty]}")
  cookbook.add_recipe(recipe)
  @usernames = cookbook.string_list
  redirect "/list"
end

post '/destroy' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.remove_recipe(params[:recipe_index])
  @usernames = cookbook.string_list
  redirect "/list"
end

post '/mark' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.mark_recipe(params[:recipe_index])
  @usernames = cookbook.string_list
  redirect "/list"
end

post '/import' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  web_import = WebImport.new
  web_import.build(params[:recipe_name])
  @usernames = ["#{web_import.result[0]}", "#{web_import.result[1]}", "#{web_import.result[2]}", "#{web_import.result[3]}", "#{web_import.result[4]}"]
  # session[:message] = @usernames.join("$") + "%" + web_import.result_details.join("$") + "%" + web_import.prep_times.join("$") + "%" + web_import.difficulties.join("$")
  session[:message] = @usernames.join("$") + "%" + web_import.result_details.first(5).join("$") + "%" + web_import.prep_times.first(5).join("$") + "%" + web_import.difficulties.first(5).join("$")
  # session[:result_details] = web_import.result_details.join("/")
  # session[:prep_times] = web_import.prep_times.join("/")
  # session[:difficulties] = web_import.difficulties.join("/")
  # redirect "/import"
  erb :importList
end

post '/importList' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  result_string = session[:message]
  # session[:message] = ""
  result = result_string.split("%")[0].split("$")
  result_details = result_string.split("%")[1].split("$")
  prep_times = result_string.split("%")[2].split("$")
  difficulties = result_string.split("%")[3].split("$")
  import_recipe = params[:recipe_index]
  cookbook.add_import(result[import_recipe.to_i - 1], result_details[import_recipe.to_i - 1], prep_times[import_recipe.to_i - 1], "difficulty: #{difficulties[import_recipe.to_i - 1]}")
  @usernames = [""]
  # redirect "/import"
  redirect "/list"
end

get '/team/:username' do
  binding.pry
  puts params[:username]
  "The username is #{params[:username]}"
end

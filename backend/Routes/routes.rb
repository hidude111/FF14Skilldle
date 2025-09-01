require 'sinatra'
require_relative './random_skill_route'
require_relative './guess_skill_route'
require_relative './suggest_skill_route'
require_relative './view_entries'
include SkillHelpers

enable :sessions


get '/' do
  redirect '/random_skill'
end

require 'sinatra'
require_relative './dbmethods'
include DBMethods

enable :sessions

get '/random_skill' do
  response = {}
  skill = get_random_skill
  if skill
    session[:guesses] = 0
    hints = build_hints(skill, session[:guesses])
    response = 
    {
      status: "start",
      title: "Guess the Skill!",
      hints: hints,
      guesses_left: 4 - session[:guesses]
    }
    content_type :json
    return response.to_json
  else
    response = 
    {
      status: "notfound",
      message: "No skills found."
    }
    content_type :json
    return response.to_json
  end
end

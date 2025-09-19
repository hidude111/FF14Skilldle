require 'sinatra'
require_relative './dbmethods'
include DBMethods


get '/random_skill' do
  content_type :json
  skill = get_random_skill

  if skill
    session[:guesses] = 0
    session[:skill]   = skill
    session[:answer]  = skill["action_name"]


    hints = build_hints(skill, session[:guesses])

    {
      status: "start",
      title: "Guess the Skill!",
      hints: hints,
      guesses_left: 4 - session[:guesses],
      answer: session[:answer],
      csrf_token: session[:csrf]
    }.to_json
  else
    {
      status: "error",
      message: "No skills found."
    }.to_json
  end
end


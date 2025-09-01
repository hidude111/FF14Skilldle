require 'sinatra'
require_relative './helpers'
include SkillHelpers

enable :sessions

get '/random_skill' do
  skill = get_random_skill
  if skill
    session[:answer] = skill['action_name']
    session[:guesses] = 0
    session[:skill] = skill
    hints = build_hints(skill, session[:guesses])
    form = <<-HTML
      <h2>Guess the Skill!</h2>
      <form action="/guess_skill" method="post">
        <input type="text" name="guess" placeholder="Enter skill name" required>
        <button type="submit">Guess</button>
      </form>
      <p>Hints so far:</p>
      #{build_hint_html(hints)}
      <p>Guesses left: #{5-session[:guesses]}</p>
    HTML
    form
  else
    "No skills found."
  end
end

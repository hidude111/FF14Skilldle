require 'sinatra'
require_relative './helpers'
require_relative '../utilities/hints'

include SkillHelpers

enable :sessions

post '/guess_skill' do
  user_guess = params['guess']
  answer = session[:answer]
  skill = session[:skill]
  session[:guesses] ||= 0
  session[:previous_guesses] ||= []

  result = {}

  if !skill_exists?(user_guess) && user_guess.strip.downcase != answer.strip.downcase
    hints = build_hints(skill, session[:guesses])
    form = <<-HTML
      <h2>Error: That skill does not exist!</h2>
      <p>Your guess: #{user_guess}</p>
      <form action="/guess_skill" method="post">
        <input type="text" name="guess" placeholder="Enter skill name" required>
        <button type="submit">Guess</button>
      </form>
    HTML
    return form
  else
    session[:guesses] += 1
  end

  hints = build_hints(skill, session[:guesses])
  user_previous_guesses = previous_guess(user_guess, session)

  if user_guess.strip.downcase == answer.strip.downcase
    session[:guesses] = 0
    session[:skill] = nil
    session[:answer] = nil
    "<h2>Correct!</h2><p>You guessed: #{user_guess}</p>"
  elsif session[:guesses] >= 5
    session[:guesses] = 0
    session[:skill] = nil
    session[:answer] = nil
    "<h2>Out of guesses!</h2><p>Your guess: #{user_guess}<br>Correct answer: #{answer}</p>#{build_hint_html(hints)}"
  else

    #feedback_html = feedback_to_html(user_guess, answer) if user_guess

    form = <<-HTML
      <h2>Incorrect! Try again.</h2>
      <p>Your guess: #{user_guess}</p>
      <form action="/guess_skill" method="post">
        <input type="text" name="guess" placeholder="Enter skill name" required>
        <button type="submit">Guess</button>
      </form>
      <p>Hints so far:</p>
      #{build_hint_html(hints)}
      <p>Guesses left: #{5-session[:guesses]}</p>
      <h2>Previous Guesses:</h2>
      <ul>
        #{user_previous_guesses}
      </ul>
    HTML
    form
  end


end

require 'sinatra'
require 'json'
require_relative './dbmethods'
require_relative '../utilities/hints'

include DBMethods

enable :sessions

post '/guess_skill' do
  user_guess = params['guess']
  answer = session[:answer]
  skill = session[:skill]
  session[:guesses] ||= 0
  response = {}

  if !skill_exists?(user_guess) && user_guess.strip.downcase != answer.strip.downcase
    hints = build_hints(skill, session[:guesses])
    response = {
      status: "error",
      message: "That skill does not exist!",
      user_guess: user_guess,
      hints: hints,
      guesses_left: 4 - session[:guesses]
    }
    content_type :json
    return response.to_json
  else
    session[:guesses] += 1
  end

  user_previous_guesses = previous_guess(user_guess, session)

  if user_guess.strip.downcase == answer.strip.downcase
    session[:guesses] = 0
    session[:skill] = nil
    session[:answer] = nil
    #"<body style=\"background-color: #403075;\"><h2>Correct!</h2><p>You guessed: #{user_guess}</p></body>"
    response = {
      status: "ok",
      message: "Correct!",
      user_guess: user_guess
    }
    content_type :json
    return response.to_json
  elsif session[:guesses] >= 4
    session[:guesses] = 0
    session[:skill] = nil
    session[:answer] = nil
    #"<body style=\"background-color: #403075;\"><h2>Out of guesses!</h2><p>Your guess: #{user_guess}<br>Correct answer: #{answer}</p>#{build_hint_html(hints)}</body>"
    response = {
      status: "ok",
      message: "Out of guesses!",
      answer: answer,
      hints: hints
    }
    content_type :json
    return response.to_json
  else
    #feedback_html = feedback_to_html(user_guess, answer) if user_guess
      response = {
      status: "incorrect",
      message: "Incorrect! Try again.",
      user_guess: user_guess,
      hints: hints,
      guesses_left: 4 - session[:guesses],
      user_previous_guesses: user_previous_guesses
    }
    content_type :json
    return response.to_json
  end


end

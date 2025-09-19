require 'sinatra'
require 'json'
require_relative './dbmethods'
require_relative '../utilities/hints'

include DBMethods


post '/guess_skill' do
  user_guess = params['guess']&.strip
  answer     = session[:answer]
  skill      = session[:skill]

  # Initialize session state
  session[:guesses] ||= 0
  session[:previous_guesses] ||= []

  # No guess provided
  if user_guess.nil? || user_guess.empty?
    return {
      status:  "error",
      message: "No guess provided"
    }.to_json
  end

  # Game state not initialized
  if answer.nil? || skill.nil?
    return {
      status:  "error",
      message: "Game state not initialized. Start a new game first.",
      answer:  answer
    }.to_json
  end

  # Generate hints
  hints = build_hints(skill, session[:guesses])

  # Validate skill existence
  unless skill_exists?(user_guess) || user_guess.downcase == answer.downcase
    return {
      status:       "error",
      message:      "That skill does not exist!",
      user_guess:   user_guess,
      hints:        hints,
      guesses_left: 4 - session[:guesses]
    }.to_json
  end

  # Record guess and increment attempts
  session[:guesses] += 1
  session[:previous_guesses] << user_guess

  # Correct answer
  if user_guess.downcase == answer.downcase
    session[:answer] = nil # clear answer to end game
    return {
      status:     "ok",
      message:    "Correct!",
      answer:     answer,
      user_guess: user_guess
    }.to_json
  end

  # Out of guesses
  if session[:guesses] >= 4
    return {
      status:  "out_of_guesses",
      message: "Out of guesses!",
      answer:  answer,
      hints:   hints
    }.to_json
  end

  # Wrong guess but still has attempts
  {
    status:                "error",
    message:               "Incorrect! Try again.",
    user_guess:            user_guess,
    hints:                 hints,
    guesses_left:          4 - session[:guesses],
    user_previous_guesses: session[:previous_guesses]
  }.to_json
end


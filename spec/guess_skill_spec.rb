require 'rack/test'
require 'rspec'
require_relative '../backend/app'   # adjust path if needed

ENV['RACK_ENV'] = 'test'

RSpec.describe "POST /guess_skill" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
  allow_any_instance_of(Object).to receive(:get_random_skill).and_return(
    {
      "action_name"   => "TestSkill",
      "type_of_action"=> "Weaponskill",
      "level"         => "Lv. 10",
      "cast_time"     => "Instant",
      "recast"        => "2.5s",
      "radius"        => "3y",
      "class_name"    => "ninja",
      "image_url"     => "https://example.com/test.png",
      "armor_type"    => "scouting",
      "class_type"    => "melee"
    }
  )
end


  let(:headers) do
    {
      "CONTENT_TYPE" => "application/x-www-form-urlencoded",
      "ACCEPT"       => "application/json",
      "HTTP_ORIGIN"  => "http://localhost:5173",
      "HTTP_HOST"    => "localhost:4567"
    }
  end


  it "1) returns success on correct guess (happy path)" do
    get '/random_skill', {}, headers
    answer = last_response_json["answer"]
    response = post '/guess_skill', { guess: answer }, headers
    guess_skill_response = JSON.parse(response.body)
    puts guess_skill_response


    expect(guess_skill_response["status"]).to eq("ok")
    expect(guess_skill_response["message"]).to eq("Correct!")
    expect(guess_skill_response["answer"]).to eq(answer)
  end

  it "2) returns error on incorrect guess" do
    get '/random_skill', {}, headers
    answer = last_response_json["answer"]
    response = post '/guess_skill', { guess: "Dragonfire Dive" }, headers
    guess_skill_response = json = JSON.parse(response.body)
    puts guess_skill_response

    expect(guess_skill_response["status"]).to eq("error")
    expect(guess_skill_response["message"]).to eq("Incorrect! Try again.")
    expect(guess_skill_response["user_guess"]).to eq("Dragonfire Dive")
    expect(guess_skill_response).to have_key("user_previous_guesses")
  end

  it "3) returns error when no guess is provided" do
    get '/random_skill', {}, headers
    answer = last_response_json["answer"]
    response = post '/guess_skill', { guess: "" }, headers
    guess_skill_response = JSON.parse(response.body)
    puts guess_skill_response

    expect(guess_skill_response["status"]).to eq("error")
    expect(guess_skill_response["message"]).to eq("No guess provided")
  end

  it "4) returns error when skill does not exist in database" do
    get '/random_skill', {}, headers
    answer = last_response_json["answer"]
    response = post '/guess_skill', { guess: "DoesNotExist" }, headers
    guess_skill_response = JSON.parse(response.body)
    puts guess_skill_response

    expect(guess_skill_response["status"]).to eq("error")
    expect(guess_skill_response["message"]).to eq("That skill does not exist!")
    expect(guess_skill_response["user_guess"]).to eq("DoesNotExist")
  end

  # Helper to parse JSON safely
  def last_response_json
    JSON.parse(last_response.body)
  end
end

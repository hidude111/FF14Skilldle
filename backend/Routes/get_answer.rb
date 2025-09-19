require_relative './dbmethods'
include DBMethods
get '/get_answer' do
  answer = session[:answer]
  if answer
    response = {
      status: "ok",
      message: "Current answer retrieved",
      answer: answer
    }
  else
    response = {
      status: "error",
      message: "No active game. Start a new game to get an answer.",
      answer: answer
    }
  end
  content_type :json
  return response.to_json
end
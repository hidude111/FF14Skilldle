require 'sinatra'
require_relative './dbmethods'
include DBMethods

enable :sessions

get '/suggest_skill' do
  query = params['q']&.strip&.downcase || ''
  suggestions = []
  if query.length > 0
    conn = db_connection
    result = conn.exec_params("SELECT action_name FROM ff14skill_attributes WHERE LOWER(action_name) LIKE $1 LIMIT 10", ["%#{query}%"])
    suggestions = result.map { |row| row['action_name'] }
    conn.close
  end
  content_type :json
  { suggestions: suggestions }.to_json
end

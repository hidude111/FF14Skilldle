require 'sinatra'
require_relative './dbmethods'
include DBMethods

enable :sessions

get '/suggest_skill' do
  query = params['q']&.strip&.downcase || ''
  suggestions = []
  if query.length > 0
    conn = db_connection
    result = get_all_entries
    suggestions = result.map { |row| row['action_name'] }
  end
  content_type :json
  { suggestions: suggestions }.to_json
end

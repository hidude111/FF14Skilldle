require 'sinatra'
require_relative './dbmethods'

get '/suggest_skill' do
  content_type :json
  query = params['query']

  if query.nil? || query.empty?
    return { suggestions: [] }.to_json
  end

  suggestions = search_skills(query) 

  {
    suggestions: suggestions
  }.to_json
end

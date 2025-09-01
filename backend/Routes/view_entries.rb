require_relative './helpers'

get '/view_entries' do
  conn = db_connection
  result = conn.exec("SELECT * FROM ff14skill_attributes ORDER BY class_name")
  entries = result.map do |row|
    {
      class_name: row['class_name'],
      level_acquired: row['level_acquired'],
      action_name: row['action_name'],
      type_of_action: row['type_of_action'],
      cast: row['cast'],
      recast: row['recast'],
      mp_cost: row['mp_cost'],
      radius: row['radius'],
      effect: row['effect'],
      image_url: row['image_url']
    }
  end
  "<ul>" + entries.map { |h| "<li>#{h}</li>" }.join + "</ul>"
end
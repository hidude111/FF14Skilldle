require 'pg'
require_relative './drg_skills_data'


def insert_skills(skills)
  conn = PG.connect(dbname: 'ff14skills', user: 'hidude111', password: '123qwe', host: 'localhost')
  skills.each do |skill|
    conn.exec_params(
      "INSERT INTO ff14skill_attributes (action_name, level_acquired, type_of_action, \"cast\", recast, mp_cost, radius, effect, class_name, image_url) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)",
      [skill[:action_name], skill[:level_acquired], skill[:type_of_action], skill[:cast], skill[:recast], skill[:mp_cost], skill[:radius], skill[:effect], skill[:class_name], skill[:image_url]]
    )
  end
  conn.close
end

insert_skills($skills)

#ast skills have been inserted
#drg skills have been inserted
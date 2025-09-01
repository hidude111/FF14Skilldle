require 'pg'
require_relative './samurai_skills'


def insert_skills(skills)
  conn = PG.connect(dbname: 'ff14skills', user: 'hidude111', password: '123qwe', host: 'localhost')
  skills.each do |skill|
    conn.exec_params(
      "INSERT INTO ff14skill_attributes (action_name, level_acquired, type_of_action, \"cast\", recast, mp_cost, radius, effect, class_name, image_url, armor_type, class_type) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)",
      [skill[:action_name], skill[:level_acquired], skill[:type_of_action], skill[:cast], skill[:recast], skill[:mp_cost], skill[:radius], skill[:effect], skill[:class_name], skill[:image_url], skill[:armor_type], skill[:class_type]]
    )
  end
  conn.close
end

insert_skills($skills)

#dragoon skills have been inserted
#drk skills have been inserted
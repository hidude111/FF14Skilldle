require 'pg'
require 'sinatra'
enable :sessions

module DBMethods
def db_connection
  PG.connect(
    dbname:   'ff14skills',
    user:     'neondb_owner',
    password: 'npg_hin54oySzNeJ',
    host:     'ep-twilight-frog-adaoukwz-pooler.c-2.us-east-1.aws.neon.tech',
    port:     5432,
    sslmode:  'require'
  )
end


  def get_random_skill
    conn = db_connection
    result = conn.exec("SELECT * FROM ff14skill_attributes ORDER BY RANDOM() LIMIT 1")
    skill = result[0]
    conn.close
    skill
  end

  def get_skill_by_name(name)
    conn = db_connection
    result = conn.exec_params("SELECT * FROM ff14skill_attributes WHERE LOWER(action_name) = LOWER($1)", [name])
    result.ntuples.zero? ? nil : result[0]
  end

  def skill_exists?(name)
    conn = db_connection
    check_result = conn.exec_params("SELECT 1 FROM ff14skill_attributes WHERE LOWER(action_name) = $1 LIMIT 1", [name.strip.downcase])
    conn.close
    check_result.ntuples > 0
  end

  def select_skill_by_class(class_name)
    conn = db_connection
    result = conn.exec_params("SELECT * FROM ff14skill_attributes WHERE LOWER(class_name) = '#{class_name}'")
    conn.close
  end

  def get_all_entries()
    conn = db_connection
    result = conn.exec_params("SELECT * FROM ff14skill_attributes")
    conn.close
  end
  
def previous_guess(user_guess)
  session[:previous_guesses] ||= []  
  session[:previous_guesses] << { guess: user_guess, attempt: session[:guesses]}
  session[:previous_guesses]
end


#currently not in use. 
  def feedback_to_html(user_guess, answer_skill)
    checks = []
    [:type_of_action, :level_acquired, :cast, :recast, :radius, :effect, :class_name, :mp_cost].each do |attr|
      user_value = user_guess[attr.to_s].to_s
      answer_value = answer_skill[attr.to_s].to_s
      match = user_value == answer_value
      mark = match ? "&#10003;" : "&#10007;"
      css_class = match ? "correct" : "incorrect"
      checks << "<li class='#{css_class}'>#{attr.to_s.gsub('_', ' ').capitalize}: #{user_value} #{mark}</li>"
    end
    "<ul class='feedback-list'>#{checks.join}</ul>"
  end



end

require 'pg'


#Currently not in use, but will be very useful when building out a feedback system
class Skill
    attr_reader :name, :type_of_action, :level_acquired, :cast, :recast, :radius, :effect, :class_name, :mp_cost

  def initialize(attributes)
    @name = attributes['action_name']
    @type_of_action = attributes['type_of_action']
    @level_acquired = attributes['level_acquired']
    @cast = attributes['cast']
    @recast = attributes['recast']
    @radius = attributes['radius']
    @effect = attributes['effect']
    @class_name = attributes['class_name']
    @mp_cost = attributes['mp_cost']
  end

  def self.all
    conn = PG.connect(dbname: 'ff14skills', user: 'your_username', password: 'your_password', host: 'localhost')
    result = conn.exec("SELECT * FROM ff14skill_attributes")
    skills = result.map { |row| new(row) }
    conn.close
    skills
  end

    skills
  end

  def self.find_by_name(name)
    conn = PG.connect(dbname: 'ff14skills', user: 'your_username', password: 'your_password', host: 'localhost')
    result = conn.exec_params("SELECT * FROM ff14skill_attributes WHERE action_name = $1 LIMIT 1", [name])
    skill = result.ntuples > 0 ? result[0] : nil
    conn.close
    skill
  end

  def self.random
    conn = PG.connect(dbname: 'ff14skills', user: 'your_username', password: 'your_password', host: 'localhost')
    result = conn.exec("SELECT * FROM ff14skill_attributes ORDER BY RANDOM() LIMIT 1")
    skill = result.ntuples > 0 ? result[0] : nil
    conn.close
    skill
  end
end
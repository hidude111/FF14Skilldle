  def build_hints(skill, guesses)
    hints = []
    hints << "Type of action: #{skill['type_of_action']}" if guesses >= 0
    hints << "Level acquired: #{skill['level_acquired']}" if guesses >= 0
    hints << "Cast time: #{skill['cast']}" if guesses >= 0
    hints << "Recast: #{skill['recast']}" if guesses >= 0
    hints << "Radius: #{skill['radius']}" if guesses >= 0
    hints << "Class Type: #{skill['class_type']}" if guesses >= 1
    hints << "Armor Type: #{skill['armor_type']}" if guesses >= 1
    hints << "Class: #{skill['class_name']}" if guesses >= 2
    hints << "Effect: #{skill['effect'].split('.').map(&:strip).join('. ')}" if guesses >= 2
    hints << "Image: <img src='#{skill['image_url']}' alt='#{skill['action_name']}'> " if guesses >= 3
    hints
  end

  def build_hint_response(hints)
    response = 
    {
      hints: hints
    }
    content_type :json
    response.to_json
    response
  end
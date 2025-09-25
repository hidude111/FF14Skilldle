  def build_hints(skill, guesses)
    hints = []
    hints << {type: "text", value: "Type of action: #{skill['type_of_action']}"} if guesses >= 0
    hints << {type: "text", value: "Level acquired: #{skill['level_acquired']}"} if guesses >= 0
    hints << {type: "text", value: "Cast time: #{skill['cast']}"} if guesses >= 0
    hints << {type: "text", value: "Recast: #{skill['recast']}"} if guesses >= 0
    hints << {type: "text", value: "Radius: #{skill['radius']}"} if guesses >= 0
    hints << {type: "text", value: "Class Type: #{skill['class_type']}"} if guesses >= 1
    hints << {type: "text", value: "Armor Type: #{skill['armor_type']}"} if guesses >= 1
    hints << {type: "text", value: "Class: #{skill['class_name']}"} if guesses >= 2
    hints << {type: "text", value: "Effect: #{skill['effect'].split('.').map(&:strip).join('. ')}"} if guesses >= 2
    hints << {type: "image", value: "#{skill['image_url']}"} if guesses >= 2
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
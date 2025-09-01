  def build_hints(skill, guesses)
    hints = []
    hints << "Type of action: #{skill['type_of_action']}" if guesses >= 0
    hints << "Level acquired: #{skill['level_acquired']}" if guesses >= 0
    hints << "Cast time: #{skill['cast']}" if guesses >= 1
    hints << "Recast: #{skill['recast']}" if guesses >= 2
    hints << "Radius: #{skill['radius']}" if guesses >= 3
    hints << "Class: #{skill['class_name']}" if guesses >= 3
    hints << "Effect: #{skill['effect'].split('.').map(&:strip).join('. ')}" if guesses >= 4
    hints << "Image: <img src='#{skill['image_url']}' alt='#{skill['action_name']}'> " if guesses >= 4
    hints
  end

  def build_hint_html(hints)
    "<ul>" + hints.map { |h| "<li>#{h} <br></li>" }.join + "</ul>"
  end
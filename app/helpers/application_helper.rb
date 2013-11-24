module ApplicationHelper
  def absolute_image_path(source)
    URI.join(root_url, image_path(source)).to_s
  end

  def game_path(game)
    "#{URI.join(root_url, 'g' + game.game_id.to_s)}"
  end
end

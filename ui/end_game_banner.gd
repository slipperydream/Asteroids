extends Label

func _ready():
	visible = false
	
func _on_main_game_over():
	visible = true
	text = "Game Over"
	add_theme_color_override("font_color", Color.CRIMSON)

extends Panel

class_name MainMenu

signal start_game
signal open_settings
signal exit_game
signal resume_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_start_game_button_pressed():
	hide()
	emit_signal("start_game")

	
func _on_settings_button_pressed():
	emit_signal("open_settings")

func _on_exit_game_button_pressed():
	emit_signal("exit_game")

func _on_resume_game_button_pressed():
	emit_signal("resume_game")
	hide()

extends Panel

class_name MainMenu

signal start_game
signal open_settings
signal exit_game
signal attract_mode

@onready var timer = $AttractModeTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()

func _on_start_game_button_pressed():
	hide()
	emit_signal("start_game")
	timer.stop()
	
func _on_settings_button_pressed():
	emit_signal("open_settings")
	timer.stop()


func _on_exit_game_button_pressed():
	emit_signal("exit_game")


func _on_attract_mode_timer_timeout():
	hide()
	emit_signal("attract_mode")

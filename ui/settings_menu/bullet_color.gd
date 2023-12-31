extends HBoxContainer

signal player_color_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	configure()

func configure():
	$ColorPickerButton.color = SettingsManager.get_player_color()
	
func _on_color_picker_button_color_changed(color):
	SettingsManager.set_player_color(color)
	emit_signal("player_color_changed", color)
	

func _on_color_picker_button_picker_created():
	var picker = $ColorPickerButton.get_picker()


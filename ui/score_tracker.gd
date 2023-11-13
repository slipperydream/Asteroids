extends VBoxContainer

func _on_main_updated_score(value):
	$Score.text = str(value)

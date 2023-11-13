extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_icon_visiblity(true)

func _on_main_game_over():
	set_icon_visiblity(false)
	
func set_icon_visiblity(value):
	for child in get_children():
		if child is TextureRect:
			child.visible = value

func _on_main_new_game():
	set_icon_visiblity(false)
	$LifeIcon1.visible = true
	$LifeIcon2.visible = true
	$LifeIcon3.visible = true

func _on_main_extra_life_earned():
	if $LifeIcon1.visible:
		$LifeIcon1.visible = true
	elif $LifeIcon2.visible:
		$LifeIcon2.visible = true
	elif $LifeIcon3.visible:
		$LifeIcon3.visible = true
	elif $LifeIcon4.visible:
		$LifeIcon4.visible = true
	elif $LifeIcon5.visible:
		$LifeIcon5.visible = true
	elif $LifeIcon6.visible:
		$LifeIcon6.visible = true
	elif $LifeIcon7.visible:
		$LifeIcon7.visible = true
	elif $LifeIcon8.visible:
		$LifeIcon8.visible = true
	elif $LifeIcon9.visible:
		$LifeIcon9.visible = true
	else:
		$LifeIcon10.visible = true

func _on_player_died():
	if $LifeIcon10.visible:
		$LifeIcon10.visible = false
	elif $LifeIcon9.visible:
		$LifeIcon9.visible = false
	elif $LifeIcon8.visible:
		$LifeIcon8.visible = false
	elif $LifeIcon7.visible:
		$LifeIcon7.visible = false
	elif $LifeIcon6.visible:
		$LifeIcon6.visible = false
	elif $LifeIcon5.visible:
		$LifeIcon5.visible = false
	elif $LifeIcon4.visible:
		$LifeIcon4.visible = false
	elif $LifeIcon3.visible:
		$LifeIcon3.visible = false
	elif $LifeIcon2.visible:
		$LifeIcon2.visible = false
	else:
		$LifeIcon1.visible = false

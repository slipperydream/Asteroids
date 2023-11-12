extends Node

@export var max_bullets : int = 500
var bullet_count : int = 0

func _ready():
	bullet_count = 0

func can_shoot():
	print(bullet_count)
	if bullet_count < max_bullets:
		return true
	else:
		print("too many bullets")
		return false

func _on_child_entered_tree(node):
	bullet_count += 1

func _on_bullet_expended():
	bullet_count -= 1

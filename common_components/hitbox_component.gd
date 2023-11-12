extends Area2D

class_name HitboxComponent

@export var damage : int = 1

func _on_area_entered(area):
	if area is HurtboxComponent:
		area.take_damage(damage)

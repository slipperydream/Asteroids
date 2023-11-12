extends RigidBody2D

class_name Bullet

signal expended
@export var speed : int = 400
@export var damage : int = 1
#@export var firing_sound 

@onready var line = $Line2D
@onready var hitbox = $HitboxComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.damage = damage
	line.default_color = SettingsManager.get_bullet_color()
	line.width = SettingsManager.get_line_width()

func _physics_process(delta):
	check_for_screenwrap()
	
func _on_timer_timeout():
	destroy()
	
func destroy():
	emit_signal("expended")
	queue_free()

func _on_hitbox_component_area_entered(area):
	destroy()

func check_for_screenwrap():
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	elif global_position.x > get_viewport_rect().size.x:
		global_position.x = 0
	elif global_position.y > get_viewport_rect().size.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = get_viewport_rect().size.y

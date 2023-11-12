extends RigidBody2D

class_name Asteroid

signal shattered
enum size {SMALL, MEDIUM, LARGE}
@export var type = size.LARGE
@export var points : int = 20
@export var hp : int = 1
@export var min_speed : float = 150.0
@export var max_speed : float = 250.0
# each smaller size moves faster than the size larger than it

@onready var line = $Line2D
@onready var health = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	line.width = SettingsManager.get_line_width()
	line.default_color = SettingsManager.get_line_color()
	health.max_health = hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	elif global_position.x > get_viewport_rect().size.x:
		global_position.x = 0
	elif global_position.y > get_viewport_rect().size.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = get_viewport_rect().size.y

func _on_health_component_killed():
	emit_signal("shattered")

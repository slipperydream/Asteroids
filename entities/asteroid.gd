extends RigidBody2D

class_name Asteroid

signal shattered
enum size {SMALL, MEDIUM, LARGE}
@export var type = size.LARGE
@export var points : int = 20

@export var min_speed : float = 150.0
@export var max_speed : float = 250.0
# each smaller size moves faster than the size larger than it

@onready var line = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	line.width = SettingsManager.get_line_width()
	line.default_color = SettingsManager.get_line_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x < 0:
		global_position.x = SettingsManager.get_window_size().x
	elif global_position.x > SettingsManager.get_window_size().x:
		global_position.x = 0
	elif global_position.y > SettingsManager.get_window_size().y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = SettingsManager.get_window_size().y


func _on_area_2d_area_entered(area):
	emit_signal("shattered", type)
	# After hitting a large Asteroid, it breaks into two mid-sized Asteroids
	# After striking a mid-size Asteroid, it splits into two small Asteroids. 


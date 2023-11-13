extends RigidBody2D

class_name Asteroid

signal shattered
enum size {SMALL, MEDIUM, LARGE}
@export var type = size.LARGE
@export var points : int = 20
@export var hp : int = 1
@export var collision_damage : int = 1
@export var min_speed : float = 150.0
@export var max_speed : float = 250.0
@export var explosion_sound : AudioStreamWAV
# each smaller size moves faster than the size larger than it

@onready var line = $Line2D
@onready var health = $HealthComponent
@onready var hitbox = $HitboxComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	line.width = SettingsManager.get_line_width()
	line.default_color = SettingsManager.get_line_color()
	health.max_health = hp
	hitbox.damage = collision_damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_screenwrap()
	
func check_for_screenwrap():
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	elif global_position.x > get_viewport_rect().size.x:
		global_position.x = 0
	elif global_position.y > get_viewport_rect().size.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = get_viewport_rect().size.y

func _on_health_component_killed(_source):
	emit_signal("shattered", global_position, type, points)
	explode()

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	queue_free()

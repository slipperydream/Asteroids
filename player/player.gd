extends CharacterBody2D

class_name Player

signal died

@export var speed = 400.0
@export var rotation_speed = 1.5
@export var hp : int = 1
@export var main_weapon : PackedScene
@export var main_weapon_cooldown : float = 0.1
@export var explosion_sound : AudioStreamWAV

@export var launch_clearance : int = 48
@export var movement_skill : TeleportComponent

@onready var ship = $Ship
@onready var thrust = $Ship/Thrust
@onready var health = $HealthComponent
@onready var main_weapon_timer = $MainWeaponTimer

var rotation_direction = 0
var forward_thrust = 0
var can_use_main_weapon : bool = false
var bullet_count : int = 0
var is_alive :bool = false

func _ready():
	is_alive = true
	visible = true
	health.max_health = hp
	ship.width = SettingsManager.get_line_width()
	ship.default_color = SettingsManager.get_player_color()
	thrust.width = SettingsManager.get_line_width()
	thrust.default_color = SettingsManager.get_player_color()
	main_weapon_timer.wait_time = main_weapon_cooldown
	main_weapon_timer.start()
	reset_pos()
	
func get_movement_input():
	rotation_direction = Input.get_axis("left", "right")
	forward_thrust = Input.get_action_strength("up")
	velocity = transform.x * forward_thrust * speed
	if forward_thrust:
		$AnimationPlayer.play("thrust")
	
func _physics_process(delta):
	if is_alive:
		if Input.is_action_pressed("main_weapon_fire"):
			if can_use_main_weapon:
				can_use_main_weapon = false
				main_weapon_timer.start()
				fire_main_weapon(transform.x)
		# Get the input direction and handle the movement/deceleration.
		get_movement_input()
		rotation += rotation_direction * rotation_speed * delta
		move_and_slide()
		check_for_screenwrap()

func _input(event):
	if event.is_action_pressed("down"):
		if movement_skill is TeleportComponent:
			health.invulnerable = true
			var new_pos = movement_skill.execute(global_position)
			$AnimationPlayer.play("teleport")
			await get_tree().create_timer(movement_skill.duration/2).timeout
			global_position = new_pos
			
func _on_teleport_component_teleported():
	health.invulnerable = false
	
func fire_main_weapon(direction : Vector2):
	if WeaponManager.can_shoot():
		var weapon = main_weapon.instantiate()
		weapon.expended.connect(WeaponManager._on_bullet_expended)
		WeaponManager.add_child(weapon)
		weapon.rotation = rotation
		weapon.linear_velocity = direction * weapon.speed + velocity
		weapon.global_position = global_position + (direction * launch_clearance)
	
func _on_main_weapon_timer_timeout():
	can_use_main_weapon = true

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
	emit_signal("died")
	explode()
	is_alive = false
	visible = false

func explode():
	AudioStreamManager.play(explosion_sound.resource_path)
	
func reset_pos():
	var screen_size = get_viewport_rect().size
	global_position = Vector2(screen_size.x/2, screen_size.y/2)
	

	

extends CharacterBody2D


@export var SPEED = 400.0
@export var rotation_speed = 1.5
@export var hp : int = 1
@export var movement_skill : TeleportComponent

@onready var ship = $Ship
@onready var thrust = $Ship/Thrust
@onready var health = $HealthComponent

var rotation_direction = 0

func _ready():
	health.max_health = hp
	ship.width = SettingsManager.get_line_width()
	ship.default_color = SettingsManager.get_player_color()
	thrust.width = SettingsManager.get_line_width()
	thrust.default_color = SettingsManager.get_player_color()
	
	
func get_input():
	rotation_direction = Input.get_axis("left", "right")
	var forward_thrust = Input.get_action_strength("up")
	velocity = transform.x * forward_thrust * SPEED
	if forward_thrust:
		$AnimationPlayer.play("thrust")
	
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	if global_position.x < 0:
		global_position.x = get_viewport_rect().size.x
	elif global_position.x > get_viewport_rect().size.x:
		global_position.x = 0
	elif global_position.y > get_viewport_rect().size.y:
		global_position.y = 0
	elif global_position.y < 0:
		global_position.y = get_viewport_rect().size.y

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

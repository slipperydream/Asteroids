extends StaticBody2D

class_name BlackHole

@export var damage : int = 0
@export var firing_sound : AudioStreamWAV
@export var black_hole_mass : float = 100.0
@export var speed_factor : float = 1.0

@onready var hitbox = $HitboxComponent
var bodies : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.damage = damage
	$AnimationPlayer.play("suck")

func _physics_process(delta):
	for body in bodies:
		var direction = body.global_position.direction_to(global_position)
		var distance = global_position.distance_squared_to(body.global_position)
		
		# ignoring gravity
		var force = black_hole_mass / pow(distance, 2)
		#if using bodies with mass
		# var force = black_hole_mass * body.mass / pow(distance, 2)
		
		var force_vector = direction * force
		
		# assuming Rigidbody2D
		body.linear_velocity += force_vector
		body.apply_central_impulse(body.linear_velocity * delta * speed_factor)
		
	
func _on_timer_timeout():
	destroy()
	
func destroy():
	queue_free()

func _on_hitbox_component_body_entered(body):
	if body.has_method("spagetthifi"):
		var index = bodies.find(body)
		if index >=0:
			bodies.remove_at(index)
		body.spagetthifi()
		body.linear_velocity = Vector2.ZERO

func _on_hitbox_component_body_exited(body):
	var index = bodies.find(body)
	if index >=0:
		bodies.remove_at(index)

func _on_pull_radius_body_entered(body):
	bodies.append(body)

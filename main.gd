extends Node2D


@export var asteroid_scenes : Array[PackedScene]
@export var starting_lives : int = 3
@export var max_lives : int = 10
@export var spawn_time : float = 2.0
@export var lowest_spawn_time : float = 0.5
@export var extra_life_score : int = 10000

# small asteroids 100 pts
# med asteroids 50 pts
# large asteroids 20 pts
# small saucers are 1000 pts each
# large saucer 500 pts
# mirror ship : 500 pts
var bonus_interval :int 
var score : int = 0
var current_level : int = 1
var lives : int = 1

# xbox achievements https://strategywiki.org/wiki/Asteroids/Achievements

@onready var spawn_location = $SpawnPath/SpawnLocation
@onready var spawn_timer = $SpawnTimer

func _ready():
	new_game()
	
func new_game():
	score = 0
	bonus_interval = extra_life_score
	start_level()
	
func start_level():
	spawn_time -= 0.1
	spawn_time = max(spawn_time, lowest_spawn_time)
	spawn_timer.wait_time = spawn_time
	for i in range(5):
		spawn_timer.start()
	
func spawn_asteroid():
	# first screen sends forth four large Asteroids. Up to 11 are eventually released on later boards. 
	# only 26 are allowed on screen at one time.
	randomize()
	# choose a random asteroid
	# should make this weighted at some point
	var asteroid = asteroid_scenes[randi() % asteroid_scenes.size()].instantiate()
	
	# choose a random spot
	spawn_location.progress_ratio = randf()
	asteroid.position = spawn_location.position
	
	# set the asteroid's direction perpendicular to the spawn path 
	# Then add some randomness
	var direction = spawn_location.rotation + PI / 2
	direction += randf_range(-PI/4, PI/4)
	asteroid.rotation = direction
	
	# set the asteroid's velocity
	var velocity = Vector2(randf_range(asteroid.min_speed, asteroid.max_speed), 0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	# spawn the asteroid
	add_child(asteroid)

func spawn_saucer():
	pass
	# large only enters from sides not top or bottom. fires randomly
	# small only eneters from the sides not top or bottom. tracks the player, but shoots a little forward or aft
func _on_spawn_timer_timeout():
	spawn_asteroid()
	spawn_timer.start()

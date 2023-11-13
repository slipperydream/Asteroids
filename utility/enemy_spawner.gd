extends Node2D 
class_name EnemySpawner
signal enemies_all_dead

@export var asteroid_scenes : Array[PackedScene]
@export var config : LevelConfig 
var spawn_time : float = 2.0
var lowest_spawn_time : float = 0.5
var initial_release : int = 4
var asteroid_limit : int = 26
var can_spawn : bool = false
var can_spawn_small_saucer : bool = false

@onready var spawn_location = $SpawnPath/SpawnLocation
@onready var spawn_timer = $SpawnTimer
@onready var main = get_tree().get_first_node_in_group("main")

var asteroid_count : int = 0

func load_config(current_level):
	spawn_time = config.spawn_time
	initial_release = config.initial_release
	asteroid_limit = config.asteroid_limit
	
	spawn_time -= (current_level/10)
	spawn_time = max(spawn_time, 0.5)
	initial_release += (current_level/4)
	asteroid_limit += (current_level/10)
	
func start_level():
	can_spawn = true
	spawn_timer.wait_time = spawn_time
	asteroid_count = 0
	for i in range(initial_release):
		spawn_asteroid(Asteroid.size.LARGE)
	spawn_timer.start()
	
func spawn_asteroid(index, pos=null):
	if can_spawn == false:
		return
		
	# first screen sends forth four large Asteroids. Up to 11 are eventually released on later boards. 
	# only 26 are allowed on screen at one time.
	randomize()
	# choose a random asteroid
	# should make this weighted at some point
	var asteroid = asteroid_scenes[index].instantiate()
	
	if pos == null:
		# choose a random spot
		spawn_location.progress_ratio = randf()
		asteroid.position = spawn_location.position
	else:
		asteroid.position = pos
	
	# set the asteroid's direction perpendicular to the spawn path 
	# Then add some randomness
	var direction = spawn_location.rotation + PI / 2
	direction += randf_range(-PI/4, PI/4)
	asteroid.rotation = direction
	
	# set the asteroid's velocity
	var velocity = Vector2(randf_range(asteroid.min_speed, asteroid.max_speed), 0)
	asteroid.linear_velocity = velocity.rotated(direction)
	
	asteroid.connect("shattered", self._on_asteroid_shattered)
	asteroid.connect("shattered", main._on_asteroid_shattered)
	# spawn the asteroid
	call_deferred("add_child", asteroid)
	asteroid_count += 1

func spawn_saucer():
	for i in range(4):
		spawn_asteroid(Asteroid.size.SMALL)
	# large only enters from sides not top or bottom. fires randomly
	# small only eneters from the sides not top or bottom. tracks the player, but shoots a little forward or aft

func stop():
	can_spawn = false
	spawn_timer.stop()
	
func _on_spawn_timer_timeout():
	if asteroid_count < asteroid_limit:
		if asteroid_count <= 0:
			emit_signal("enemies_all_dead")
		else:
			var result = randi_range(0,10)
			if result == 0:
				spawn_saucer()
			else:
				spawn_asteroid(Asteroid.size.LARGE)
	spawn_timer.start()
	
func _on_asteroid_shattered(pos, size, _points):
	asteroid_count -= 1
	print("shattered")
	if size > 0:
		spawn_asteroid(size-1, pos)
		spawn_asteroid(size-1, pos)

func _on_main_extra_life_earned():
	if can_spawn_small_saucer == false:
		can_spawn_small_saucer = true

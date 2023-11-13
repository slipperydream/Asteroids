extends Node2D

signal new_level
signal new_game
signal game_over
signal updated_score
signal extra_life_earned

@export var starting_lives : int = 3
@export var max_lives : int = 10
@export var extra_life_score : int = 10000

@onready var enemy_spawner = $EnemySpawner
@onready var player = $Player
@onready var countdown = $CountdownPanel

var bonus_interval :int 
var score : int = 0
var current_level : int = 1
var lives : int = 1

# xbox achievements https://strategywiki.org/wiki/Asteroids/Achievements

func _ready():
	player.is_alive = false
	player.visible = false
	AudioStreamManager.start()
	start_game()
	
func start_game():
	emit_signal("new_game")
	update_score(0)
	current_level = 0
	lives = starting_lives
	bonus_interval = extra_life_score
	load_level()

func load_level():
	enemy_spawner.load_config(current_level)
	enemy_spawner.start_level()
	emit_signal("new_level", current_level)

func _on_enemy_spawner_enemies_all_dead():
	enemy_spawner.stop()
	current_level += 1
	await get_tree().create_timer(5).timeout
	load_level()

func update_score(value):
	# small asteroids 100 pts
	# med asteroids 50 pts
	# large asteroids 20 pts
	# small saucers are 1000 pts each
	# large saucer 500 pts
	# mirror ship : 500 pts
	score += value
	emit_signal("updated_score", score)
	
	if score > extra_life_score:
		emit_signal("extra_life_earned")
		extra_life_score += bonus_interval
	
func _on_asteroid_shattered(_pos, _size, points):
	update_score(points)

func _on_extra_life_earned():
	lives += 1

func _on_player_died():
	lives -= 1
	if lives <= 0:
		emit_signal("game_over")
	else:
		countdown.start()

func _on_game_over():
	await get_tree().create_timer(5).timeout
	#start_game()

func _on_countdown_panel_countdown_over():
	player.reset()

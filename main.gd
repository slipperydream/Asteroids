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
@onready var countdown = $CanvasLayer/CountdownPanel
@onready var settings = $CanvasLayer/SettingsMenu
@onready var main_menu = $CanvasLayer/MainMenu
@onready var pause_menu = $CanvasLayer/PauseMenu

var bonus_interval :int 
var score : int = 0
var current_level : int = 1
var lives : int = 1
var attract_mode : bool = false
var last_menu = null
# xbox achievements https://strategywiki.org/wiki/Asteroids/Achievements

func _ready():
	player.is_alive = false
	player.visible = false
	AudioStreamManager.start()
	
func start_game(computer_control):
	emit_signal("new_game")
	update_score(0)
	current_level = 0
	lives = starting_lives
	bonus_interval = extra_life_score
	load_level()
	if computer_control:
		attract_mode = true
		player.computer_control = true
	else: 
		player.computer_control = false

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
	HighScoreSystem.check_for_high_score(score)
	
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
	HighScoreSystem.check_for_high_score(score)
	await get_tree().create_timer(5).timeout
	#start_game()

func _on_countdown_panel_countdown_over():
	player.reset()

func _on_main_menu_exit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)

func _on_main_menu_start_game():
	start_game(false)
	last_menu = null

func _on_main_menu_open_settings():
	settings.show()
	main_menu.hide()
	last_menu = main_menu

func _on_main_menu_attract_mode():
	start_game(true)

func _on_settings_menu_settings_closed():
	if get_tree().paused:
		get_tree().paused = false
	if last_menu:
		last_menu.show()

func _on_pause_menu_exit_game():
	HighScoreSystem.check_for_high_score(score)
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)

func _on_pause_menu_resume_game():
	get_tree().paused = false

func _on_pause_menu_open_settings():
	pause_menu.hide()
	settings.show()
	last_menu = pause_menu

func _on_pause_menu_start_game():
	HighScoreSystem.check_for_high_score(score)
	start_game(false)
	
func _input(event):
	if event.is_action_pressed("pause_game"):
		get_tree().paused = false
		pause_menu.show()

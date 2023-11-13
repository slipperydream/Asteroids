extends Panel

signal countdown_over

@onready var clock = $clock
@export var countdown_time : int = 3
var countdown_interval : int 

func _ready():
	visible = false

func start():
	countdown_interval = countdown_time
	visible = true
	update_clock()
	$Timer.start()

func _on_timer_timeout():
	countdown_time -= 1
	update_clock()
	if countdown_time > 0:
		$Timer.start()
	else:
		emit_signal("countdown_over")
		countdown_time = countdown_interval
		visible = false

func update_clock():
	clock.text = str(countdown_time)

func _on_main_game_over():
	$Timer.stop()

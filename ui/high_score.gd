extends VBoxContainer

var starting_score : String = "00000000"
@onready var high_score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(starting_score)
	high_score = HighScoreSystem.get_high_score()
	update_score(high_score)

func update_score(value):
	$Score.text = str(value)

extends Node2D

class_name TeleportComponent
signal teleported

@export var edge_buffer : int = 10
@export var duration : float = 1.0

func execute(current_pos):
	$Timer.wait_time = duration
	$Timer.start()
	randomize()
	
	var rect = get_viewport_rect().size
	var pos = Vector2.ZERO
	
	while true:
		pos.x = randi_range(edge_buffer, rect.x-edge_buffer)
		pos.y = randi_range(edge_buffer, rect.y-edge_buffer)
		if pos != current_pos:
			break
			
	return pos

func _on_timer_timeout():
	teleported.emit()

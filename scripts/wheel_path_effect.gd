extends Line2D

@export var max_length: int = 30
@onready var timer: Timer = $Timer
@export var interval: float

func _ready() -> void:
	timer.wait_time = interval

func _on_timer_timeout() -> void:
	var target_pos: Vector2 = get_parent().global_position
	
	# Add the parent's current position to the head of the line
	add_point(target_pos)
	
	# Trim points that exceed the trail limit
	while get_point_count() > max_length:
		remove_point(0)

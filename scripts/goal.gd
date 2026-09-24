extends Area2D

@onready var checkpoint_manager: Node = %CheckpointManager

func _on_area_entered(area: Area2D) -> void:
	# check if there no winner yet
	# then check if the car is passed all laps
	# if all true, make that car in group "winner"
	var car = area.owner
	var current_lap = car.get_meta("lap")
	var lap_count = checkpoint_manager.lap_count
	var winner_count = get_tree().get_nodes_in_group("winner").size()
	var winner_is_presented = false if winner_count == 0 else true
	if current_lap == lap_count and winner_is_presented == false:
		print("You win")
		car.add_to_group("winner")
		
	

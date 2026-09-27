extends Area2D

@onready var manager: Node = %GameManager

func _on_area_entered(area: Area2D) -> void:
	# check if there no winner yet
	# then check if the car is passed all laps
	# if all true, signal the "car" to game manager
	var car = area.owner
	var current_lap = car.get_meta("lap")
	var lap_count = manager.lap_count
	var winner_count = get_tree().get_nodes_in_group("winner").size()
	var winner_is_presented = false if winner_count == 0 else true
	if current_lap == lap_count and winner_is_presented == false:
		manager.car_win(car)
		

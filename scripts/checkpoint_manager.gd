extends Node

var current_lap = 0
var lap_count: int

func _process(delta: float) -> void:
	var all_checkpoint = get_tree().get_nodes_in_group("checkpoint")
			
	lap_count = all_checkpoint.size()
			
func passed():
	current_lap += 1

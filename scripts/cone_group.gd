extends Node2D

func _ready() -> void:
	randomness()
	
func randomness():
	var childs = get_children()

	for child in childs:
		if child is RigidBody2D:
			var randomrange = [randi_range(-1500,-400), randi_range(400,1500)]
			child.linear_velocity = Vector2(randomrange.pick_random(), randomrange.pick_random())
			
			var dead_or_alive = [false, true].pick_random()
			if dead_or_alive == false: child.queue_free()

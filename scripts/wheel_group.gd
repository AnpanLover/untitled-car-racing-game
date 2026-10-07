extends Node2D

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	randomness()

func randomness():
	var childs = get_children()
	var random = RandomNumberGenerator.new().randi_range(0, 2)

	for child in childs:
		if child is RigidBody2D:
			var sprite = child.get_node("Sprite2D")
			sprite.frame = random

			var randomrange = [randi_range(-1500,-400), randi_range(400,1500)]
			child.linear_velocity = Vector2(randomrange.pick_random(), randomrange.pick_random())
			
			var dead_or_alive = [false, true].pick_random()
			if dead_or_alive == false: child.queue_free()
